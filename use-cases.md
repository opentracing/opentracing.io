---
layout: page
title: Instrumentation for Common Use Cases
---
<div id="toc"></div>

This page aims to illustrate common use cases that developers who instrument their applications and libraries with OpenTracing API need to deal with.

### Tracing a Function

```python
    def top_level_function():
        span1 = tracer.start_trace('top_level_function')
        try:
            . . . # business logic
        finally:
            span1.finish()
```

As a follow-up, suppose that as part of the business logic above we call another `function2` that we also want to trace. In order to attach that function to the ongoing trace, we need a way to access `span1`. We discuss how it can be done later, for now let's assume we have a helper function `get_current_span` for that:

```python
    def function2():
        span2 = get_current_span().start_child('function2') \
            if get_current_span() else None
        try:
            . . . # business logic
        finally:
            if span2:
                span2.finish()
```

We assume that for whatever reason develper does not want to start a new trace in this function if one hasn't been started by the caller already, so we account for `get_current_span` potentially returning `None`.

These two examples are intentionally naive. Usually developers will not want to pollute their business functions directly with tracing code, but use other means like a [function decorator in Python](https://github.com/uber-common/opentracing-python-instrumentation/blob/master/opentracing_instrumentation/local_span.py#L59):

```python
    @traced_function
    def top_level_function():
        ... # business logic
```

### Tracing Server Endpoints

When a server wants to trace execution of a request, it generally needs to go through these steps:

  1. Attempt to deserialize Trace Context from the incoming request, in case the trace has already been started by the client.
  1. Depending on the outcome, either start a new trace, or join the existing trace using deserialized Trace Context. This operation starts a new Span.
  1. Store the newly created span in some _request context_ that is propagated throughout the application, either by application code, or by the RPC framework.
  1. Finally, close the span using `span.finish()` when the server has finished processing the request.

#### Deserializing Trace Conext from Incoming Request

Let's assume that we have an HTTP server, and the Trace Context is propagated from the client via HTTP headers, accessible via `request.headers`:

```python
    context = tracer.trace_context_from_text(
        trace_context_id=request.headers,
        trace_attributes=request.headers
    )
```

Here we set both arguments of the decoding method to the `headers` map. The Tracer object knows which headers it needs to read in order to reconstruct Trace Context, which comprises a trace context ID and trace attributes.

#### Starting a Server-Side Span

The `context` object above can be `None`, if the Tracer did not find relevant headers in the incoming request, either because the client did not send them, or maybe the client is running with a different tracer implementation (e.g. Zipkin vs. AppDash). In this case the server needs to start a brand new trace, otherwise it should join the existing trace:

```python
    if context is None:
        span = tracer.start_trace(operation_name=operation)
    else:
        span = tracer.join_trace(operation_name=operation,
                                 parent_trace_context=context)
    span.set_tag('http.method', request.method)
    span.set_tag('http.url', request.full_url)
```

The `operation` above refers to the name the server wants to give to the Span. For example, if the HTTP request was a POST against `/save_user/123`, the operation name can be set to `post:/save_user/`. OpenTracing API does not dictate how application calls the spans.

The `set_tag` calls are examples of recording additional information in the span about the request.

#### In-Process Request Context Propagation

Request context propagation refers to application's ability to associate a certain _context_ with the incoming request such that this context is accessible in all other layers of the application within the same process. It can be used to provide application layers with access to request-specific values such as the identity of the end user, authorization tokens, and the request's deadline. It can also be used for transporting the current tracing Span.

The methods of request context propagation are outside the scope of the OpenTracing API, but it is worth mentioning them here to better understand the following sections. There are two commonly used methods of propagation:

  1. Explicit propagation - the application code is structured to pass around a certain context object. For example, see https://blog.golang.org/context.
  1. Implicit propagation - the context is stored in platform-specific storage that allows it to be retrieved from any place in the application. Often used by RPC frameworks by utilizing such mechanisms as thread-local or continuation-local storage, or even global variables (in case of single-threaded processes).

### Tracing Client Calls

When an application acts as an RPC client, it is expected to start a new tracing Span before making an outgoing request, and serialize the new span's Trace Context into that request. The following example shows how it can be done for an HTTP request. 

```python
    def traced_request(request, operation, http_client):
        # retrieve current span from propagated request context
        parent_span = get_current_span()

        # start a new child span or a brand new trace if no parent
        if parent_span is None:
            span = tracer.start_trace(operation_name=operation)
        else:
            span = parent_span.start_child(operation_name=operation)
        span.set_tag('server.http.url', request.full_url)

        # encode Trace Context into HTTP request headers
        h_ctx, h_attr = tracer.trace_context_to_text(
            trace_context=span.trace_context)

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
```

  * The `get_current_span()` function is not a part of the OpenTracing API. It is meant to represent some util method of retrieving the current span from the current request context propagated implicitly (as is often the case in Python).
  * The encoding function `trace_context_to_text` returns two maps, one representing the encoding of the trace context identity, the other the trace context attributes. We copy both maps into the HTTP request headers.
  * We assume the HTTP client is asynchronous, so it returns a Future, and we need to add an on-completion callback to be able to finish the current child span.
  * If HTTP client returns a future with exception, we log the exception to the span with `log_event_with_payload` method.
  * Because the HTTP client may throw an exception even before returning a Future, we use a try/catch block to ensure that we finish the span in all circumstances.


### Using Distributed Context Propagation

The client and server examples above took care of propagating Trace Context on the wire, which includes any Trace Attributes.  The client may use the Trace Attributes to pass additional data to the server and any other downstream server it might call.

```python

    # client side
    span.trace_context.set_attribute('auth-token', '.....')

    # server side (one or more levels down from the client)
    token = span.trace_context.get_attribute('auth-token')
```

### Logging Events

We have already used `log_event_with_payload` in the client span use case. Events can be logged without a payload, and not just where the span is being created / finished. For example, the application may record a cache miss event in the middle of execution, as long as it can get access to the current span from request context:

```python

    span = get_current_span()
    span.log_event('cache-miss') 
```

The tracer automatically records a timestamp of the event, in contrast with tags that apply to the entire span. In the future versions of the API it will be possible to associate an externally provided timestamp with the event, e.g. see [pull request #38](https://github.com/opentracing/opentracing-go/pull/38).

### Recording Spans With External Timestamps

There are scenarios when it is impractical to incorporate an OpenTracing compatible tracer into a service, for various reasons. For example, a user may have a log file of what's essentially span data coming from a black-box process (e.g. HAProxy). In order to get the data into an OpenTracing-compatible system, the API needs a way to record spans with extrenally captured timestamps. The current version of API does not have that capability: see [issue #20](https://github.com/opentracing/opentracing.github.io/issues/20).

### Setting "Debug" Mode

Most tracing systems apply sampling to minimize the amount of trace data sent to the system.  Sometimes developers want to have a way to ensure that a particular trace is going to be recorded (sampled) by the tracing system, e.g. by including a special parameter in the HTTP request, like `debug=true`. The OpenTracing API does not have any insight into sampling techniques used by the implementation, so there is no explicit API to force it. However, the implementations are advised to recognized the `debug` Trace Attribute and take measures to record the span. In order to pass this attribute to tracing systems that rely on pre-trace sampling, the following approach can be used:

```python

    if request.get('debug'):
        trace_context = tracer.new_root_trace_context()
        trace_context.set_attribute('debug', True)
        span = tracer.start_span_with_context(
            operation_name=operation, 
            trace_context=trace_context)
```
