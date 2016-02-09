---
layout: page
title: Instrumentation for Common Use Cases
---
<div id="toc"></div>

This page aims to illustrate common use cases that developers who instrument their applications and libraries with OpenTracing API need to deal with.

### Tracing a Function

{% highlight python %}
def top_level_function():
    span1 = tracer.start_trace('top_level_function')
    try:
        . . . # business logic
    finally:
        span1.finish()
{% endhighlight %}

As a follow-up, suppose that as part of the business logic above we call another `function2` that we also want to trace. In order to attach that function to the ongoing trace, we need a way to access `span1`. We discuss how it can be done later, for now let's assume we have a helper function `get_current_span` for that:

{% highlight python %}
def function2():
    span2 = get_current_span().start_child('function2') \
        if get_current_span() else None
    try:
        . . . # business logic
    finally:
        if span2:
            span2.finish()
{% endhighlight %}

We assume that, for whatever reason, the developer does not want to start a new trace in this function if one hasn't been started by the caller already, so we account for `get_current_span` potentially returning `None`.

These two examples are intentionally naive. Usually developers will not want to pollute their business functions directly with tracing code, but use other means like a [function decorator in Python](https://github.com/uber-common/opentracing-python-instrumentation/blob/master/opentracing_instrumentation/local_span.py#L59):

{% highlight python %}
@traced_function
def top_level_function():
    ... # business logic
{% endhighlight %}

### Tracing Server Endpoints

When a server wants to trace execution of a request, it generally needs to go through these steps:

  1. Attempt to join an existing trace given a Span that's been propagated alongside the incoming request (in case the trace has already been started by the client), or create a new trace if no such propagated Span could be found.
  1. Store the newly created Span in some _request context_ that is propagated throughout the application, either by application code, or by the RPC framework.
  1. Finally, close the Span using `span.finish()` when the server has finished processing the request.

#### Joining to a Trace from an Incoming Request

Let's assume that we have an HTTP server, and the Span is propagated from the client via HTTP headers, accessible via `request.headers`:

{% highlight python %}
span = tracer.join_trace_from_text(
    operation_name=operation,
    context_snapshot=request.headers,
    trace_attributes=request.headers
)
{% endhighlight %}

Here we set both arguments of the decoding method to the `headers` map. The Tracer object knows which headers it needs to read in order to reconstruct the context snapshot and any Trace Attributes.

The `operation` above refers to the name the server wants to give to the Span. For example, if the HTTP request was a POST against `/save_user/123`, the operation name can be set to `post:/save_user/`. OpenTracing API does not dictate how applications name the spans.

#### Joining to or Starting a Trace from an Incoming Request

The `span` object above can be `None` if the Tracer did not find relevant headers in the incoming request: presumably because the client did not send them. In this case the server needs to start a brand new trace.

{% highlight python %}
span = tracer.join_trace_from_text(
    operation_name=operation,
    context_snapshot=request.headers,
    trace_attributes=request.headers
)
if span is None:
    span = tracer.start_trace(operation_name=operation)
span.set_tag('http.method', request.method)
span.set_tag('http.url', request.full_url)
{% endhighlight %}

The `set_tag` calls are examples of recording additional information in the Span about the request.

#### In-Process Request Context Propagation

Request context propagation refers to application's ability to associate a certain _context_ with the incoming request such that this context is accessible in all other layers of the application within the same process. It can be used to provide application layers with access to request-specific values such as the identity of the end user, authorization tokens, and the request's deadline. It can also be used for transporting the current tracing Span.

Implementation of request context propagation is outside the scope of the OpenTracing API, but it is worth mentioning them here to better understand the following sections. There are two commonly used techniques of context propagation:

##### Implicit Propagation

In implicit propagation techniques the context is stored in platform-specific storage that allows it to be retrieved from any place in the application. Often used by RPC frameworks by utilizing such mechanisms as thread-local or continuation-local storage, or even global variables (in case of single-threaded processes).

The downside of this approach is that it almost always has a performance penalty, and in platforms like Go that do not support thread-local storage implicit propagation is nearly impossible to implement.

##### Explicit Propagation

In explicit propagation techniques the application code is structured to pass around a certain _context_ object:

{% highlight go %}
func HandleHttp(w http.ResponseWriter, req *http.Request) {
    ctx := context.Background()
    ...
    BusinessFunction1(ctx, arg1, ...)
}

func BusinessFunction1(ctx context.Context, arg1...) {
    ...
    BusinessFunction2(ctx, arg1, ...)
}

func BusinessFunction2(ctx context.Context, arg1...) {
    span := SpanFromContext(ctx)
    span.StartChild(...)
    ...
}
{% endhighlight %}

The downside of explicit context propagation is that it leaks what could be considered an infrastructure concern into the application code. This [Go blog post](https://blog.golang.org/context) provides an in-depth overview and justification of this approach.

### Tracing Client Calls

When an application acts as an RPC client, it is expected to start a new tracing Span before making an outgoing request, and propagate the new Span along with that request. The following example shows how it can be done for an HTTP request. 

{% highlight python %}
def traced_request(request, operation, http_client):
    # retrieve current span from propagated request context
    parent_span = get_current_span()

    # start a new child span or a brand new trace if no parent
    if parent_span is None:
        span = tracer.start_trace(operation_name=operation)
    else:
        span = parent_span.start_child(operation_name=operation)
    span.set_tag('http.url', request.full_url)

    # Propagate the Span via HTTP request headers
    h_ctx, h_attr = tracer.propagate_span_as_text(span)

    for key, value in h_ctx.iteritems():
        request.add_header(key, value)
    if h_attr:
        for key, value in h_attr.iteritems():
            request.add_header(key, value)

    # define a callback where we can finish the span 
    def on_done(future):
        if future.exception():
            span.log_event_with_payload('exception', exception)
        else:
            span.set_tag('http.status_code', future.result().status_code)
        span.finish()

    try:
        future = http_client.execute(request)
        future.add_done_callback(on_done)
        return future
    except Exception e:
        span.log_event_with_payload('exception', e)
        span.finish()
        raise
{% endhighlight %}

  * The `get_current_span()` function is not a part of the OpenTracing API. It is meant to represent some util method of retrieving the current Span from the current request context propagated implicitly (as is often the case in Python).
  * The encoding function `propagate_span_as_text` returns two maps, one representing a snapshot of the Span's context, and the other the Trace Attributes. We copy both maps into the HTTP request headers.
  * We assume the HTTP client is asynchronous, so it returns a Future, and we need to add an on-completion callback to be able to finish the current child Span.
  * If the HTTP client returns a future with exception, we log the exception to the Span with `log_event_with_payload` method.
  * Because the HTTP client may throw an exception even before returning a Future, we use a try/catch block to finish the Span in all circumstances, to ensure it is reported and avoid leaking resources.


### Using Distributed Context Propagation

The client and server examples above propagated the Span/Trace over the wire, including any Trace Attributes. The client may use the Trace Attributes to pass additional data to the server and any other downstream server it might call.

{% highlight python %}
# client side
span.set_trace_attribute('auth-token', '.....')

# server side (one or more levels down from the client)
token = span.get_trace_attribute('auth-token')
{% endhighlight %}

### Logging Events

We have already used `log_event_with_payload` in the client Span use case. Events can be logged without a payload, and not just where the Span is being created / finished. For example, the application may record a cache miss event in the middle of execution, as long as it can get access to the current Span from the request context:

{% highlight python %}
span = get_current_span()
span.log_event('cache-miss') 
{% endhighlight %}

The tracer automatically records a timestamp of the event, in contrast with tags that apply to the entire Span. It is also possible to associate an externally provided timestamp with the event, e.g. see [Log (Go)](https://github.com/opentracing/opentracing-go/blob/ca5c92cf/span.go#L53).

### Recording Spans With External Timestamps

There are scenarios when it is impractical to incorporate an OpenTracing compatible tracer into a service, for various reasons. For example, a user may have a log file of what's essentially Span data coming from a black-box process (e.g. HAProxy). In order to get the data into an OpenTracing-compatible system, the API needs a way to record spans with extrenally captured timestamps. The current version of API does not have that capability: see [issue #20](https://github.com/opentracing/opentracing.github.io/issues/20).

### Setting "Debug" Mode

`TODO: re-introduce an API for this when we tackle explicit Span timestamps.`

> Most tracing systems apply sampling to minimize the amount of trace data sent to the system.  Sometimes developers want to have a way to ensure that a particular trace is going to be recorded (sampled) by the tracing system, e.g. by including a special parameter in the HTTP request, like `debug=true`. The OpenTracing API does not have any insight into sampling techniques used by the implementation, so there is no explicit API to force it. However, the implementations are advised to recognized the `debug` Trace Attribute and take measures to record the Span. In order to pass this attribute to tracing systems that rely on pre-trace sampling, the following approach can be used:
> 
>     if request.get('debug'):
>         trace_context = tracer.new_root_trace_context()
>         trace_context.set_attribute('debug', True)
>         span = tracer.start_span_with_context(
>             operation_name=operation, 
>             trace_context=trace_context)
