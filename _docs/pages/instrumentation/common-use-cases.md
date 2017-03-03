# Common use cases

This page aims to illustrate common use cases that developers who instrument their applications and libraries with OpenTracing API need to deal with.

## Stepping Back: Who is OpenTracing for?

OpenTracing is a thin standardization layer that sits between application/library code and various systems that consume tracing and causality data. Here is a diagram:

~~~
   +-------------+  +---------+  +----------+  +------------+
   | Application |  | Library |  |   OSS    |  |  RPC/IPC   |
   |    Code     |  |  Code   |  | Services |  | Frameworks |
   +-------------+  +---------+  +----------+  +------------+
          |              |             |             |
          |              |             |             |
          v              v             v             v
     +-----------------------------------------------------+
     | · · · · · · · · · · OpenTracing · · · · · · · · · · |
     +-----------------------------------------------------+
       |               |                |               |
       |               |                |               |
       v               v                v               v
 +-----------+  +-------------+  +-------------+  +-----------+
 |  Tracing  |  |   Logging   |  |   Metrics   |  |  Tracing  |
 | System A  |  | Framework B |  | Framework C |  | System D  |
 +-----------+  +-------------+  +-------------+  +-----------+
~~~

**Application Code**: Developers writing application code can use OpenTracing to describe causality, demarcate control flow, and add fine-grained logging information along the way.

**Library Code**: Similarly, libraries that take intermediate control of requests can integrate with OpenTracing for similar reasons. For instance, a web middleware library can use OpenTracing to create spans for request handling, or an ORM library can use OpenTracing to describe higher-level ORM semantics and measure execution for specific SQL queries.

**OSS Services**: Beyond embedded libraries, entire OSS services may adopt OpenTracing to integrate with distributed traces initiating in – or propagating to – other processes in a larger distributed system. For instance, an HTTP load balancer may use OpenTracing to decorate requests, or a distributed key:value store may use OpenTracing to explain the performance of reads and writes.

**RPC/IPC Frameworks**: Any subsystem tasked with crossing process boundaries may use OpenTracing to standardize the format of tracing state as it injects into and extracts from various wire formats and protocols.

All of the above should be able to use OpenTracing to describe and propagate distributed traces **without knowledge of the underlying OpenTracing implementation**.

### OpenTracing priorities

Since there are many orders of magnitude more programmers and applications *above* the OpenTracing layer (rather than below it), the APIs and use cases prioritize ease-of-use in that direction. While there are certainly ample opportunities for helper libraries and other abstractions that save time and effort for OpenTracing implementors, the use cases in this document are restricted to callers (rather than callees) of OpenTracing APIs.

Without further ado:

## Motivating Use Cases

### Tracing a Function

```python
def top_level_function():
    span1 = tracer.start_span('top_level_function')
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

We assume that, for whatever reason, the developer does not want to start a new trace in this function if one hasn't been started by the caller already, so we account for `get_current_span` potentially returning `None`.

These two examples are intentionally naive. Usually developers will not want to pollute their business functions directly with tracing code, but use other means like a [function decorator in Python](https://github.com/uber-common/opentracing-python-instrumentation/blob/master/opentracing_instrumentation/local_span.py#L59):

```python
@traced_function
def top_level_function():
    ... # business logic
```

### Tracing Server Endpoints

When a server wants to trace execution of a request, it generally needs to go through these steps:

  1. Attempt to extract a SpanContext that's been propagated alongside the incoming request (in case the trace has already been started by the client), or start a new trace if no such propagated SpanContext could be found.
  1. Store the newly created Span in some _request context_ that is propagated throughout the application, either by application code, or by the RPC framework.
  1. Finally, close the Span using `span.finish()` when the server has finished processing the request.

#### Extracting a SpanContext from an Incoming Request

Let's assume that we have an HTTP server, and the SpanContext is propagated from the client via HTTP headers, accessible via `request.headers`:

```python
extracted_context = tracer.extract(
    format=opentracing.HTTP_HEADER_FORMAT,
    carrier=request.headers
)
```

Here we use the `headers` map as the carrier. The Tracer object knows which headers it needs to read in order to reconstruct the tracer state and any Baggage.

#### Continuing or Starting a Trace from an Incoming Request

The `extracted_context` object above can be `None` if the Tracer did not find relevant headers in the incoming request: presumably because the client did not send them. In this case the server needs to start a brand new trace.

```python
extracted_context = tracer.extract(
    format=opentracing.HTTP_HEADER_FORMAT,
    carrier=request.headers
)
if extracted_context is None:
    span = tracer.start_span(operation_name=operation)
else:
    span = tracer.start_span(operation_name=operation, child_of=extracted_context)
span.set_tag('http.method', request.method)
span.set_tag('http.url', request.full_url)
```

The `set_tag` calls are examples of recording additional information in the Span about the request.

The `operation` above refers to the name the server wants to give to the Span. For example, if the HTTP request was a POST against `/save_user/123`, the operation name can be set to `post:/save_user/`. The OpenTracing API does not dictate how applications name the spans.

#### In-Process Request Context Propagation

Request context propagation refers to application's ability to associate a certain _context_ with the incoming request such that this context is accessible in all other layers of the application within the same process. It can be used to provide application layers with access to request-specific values such as the identity of the end user, authorization tokens, and the request's deadline. It can also be used for transporting the current tracing Span.

Implementation of request context propagation is outside the scope of the OpenTracing API, but it is worth mentioning them here to better understand the following sections. There are two commonly used techniques of context propagation:

##### Implicit Propagation

In implicit propagation techniques the context is stored in platform-specific storage that allows it to be retrieved from any place in the application. Often used by RPC frameworks by utilizing such mechanisms as thread-local or continuation-local storage, or even global variables (in case of single-threaded processes).

The downside of this approach is that it almost always has a performance penalty, and in platforms like Go that do not support thread-local storage implicit propagation is nearly impossible to implement.

##### Explicit Propagation

In explicit propagation techniques the application code is structured to pass around a certain _context_ object:

```go
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
    parentSpan := opentracing.SpanFromContext(ctx)
    childSpan := opentracing.StartSpan(
        "...", opentracing.ChildOf(parentSpan.Context()), ...)
    ...
}
```

The downside of explicit context propagation is that it leaks what could be considered an infrastructure concern into the application code. This [Go blog post](https://blog.golang.org/context) provides an in-depth overview and justification of this approach.

### Tracing Client Calls

When an application acts as an RPC client, it is expected to start a new tracing Span before making an outgoing request, and propagate the new Span along with that request. The following example shows how it can be done for an HTTP request.

```python
def traced_request(request, operation, http_client):
    # retrieve current span from propagated request context
    parent_span = get_current_span()

    # start a new span to represent the RPC
    span = tracer.start_span(
        operation_name=operation,
        child_of=parent_span.context,
        tags={'http.url': request.full_url}
    )

    # propagate the Span via HTTP request headers
    tracer.inject(
        span.context,
        format=opentracing.HTTP_HEADER_FORMAT,
        carrier=request.headers)

    # define a callback where we can finish the span
    def on_done(future):
        if future.exception():
            span.log(event='rpc exception', payload=exception)
        span.set_tag('http.status_code', future.result().status_code)
        span.finish()

    try:
        future = http_client.execute(request)
        future.add_done_callback(on_done)
        return future
    except Exception e:
        span.log(event='general exception', payload=e)
        span.finish()
        raise
```

  * The `get_current_span()` function is not a part of the OpenTracing API. It is meant to represent some util method of retrieving the current Span from the current request context propagated implicitly (as is often the case in Python).
  * We assume the HTTP client is asynchronous, so it returns a Future, and we need to add an on-completion callback to be able to finish the current child Span.
  * If the HTTP client returns a future with exception, we log the exception to the Span with `log` method.
  * Because the HTTP client may throw an exception even before returning a Future, we use a try/catch block to finish the Span in all circumstances, to ensure it is reported and avoid leaking resources.


### Using Baggage / Distributed Context Propagation

The client and server examples above propagated the Span/Trace over the wire, including any Baggage. The client may use the Baggage to pass additional data to the server and any other downstream server it might call.

```python
# client side
span.context.set_baggage_item('auth-token', '.....')

# server side (one or more levels down from the client)
token = span.context.get_baggage_item('auth-token')
```

### Logging Events

We have already used `log` in the client Span use case. Events can be logged without a payload, and not just where the Span is being created / finished. For example, the application may record a cache miss event in the middle of execution, as long as it can get access to the current Span from the request context:

```python
span = get_current_span()
span.log(event='cache-miss')
```

The tracer automatically records a timestamp of the event, in contrast with tags that apply to the entire Span. It is also possible to associate an externally provided timestamp with the event, e.g. see [Log (Go)](https://github.com/opentracing/opentracing-go/blob/ca5c92cf/span.go#L53).

### Recording Spans With External Timestamps

There are scenarios when it is impractical to incorporate an OpenTracing compatible tracer into a service, for various reasons. For example, a user may have a log file of what's essentially Span data coming from a black-box process (e.g. HAProxy). In order to get the data into an OpenTracing-compatible system, the API needs a way to record spans with externally defined timestamps.

```python
explicit_span = tracer.start_span(
    operation_name=external_format.operation,
    start_time=external_format.start,
    tags=external_format.tags
)
explicit_span.finish(
    finish_time=external_format.finish,
    bulk_logs=map(..., external_format.logs)
)
```

### Setting Sampling Priority Before the Trace Starts

Most distributed tracing systems apply sampling to reduce the amount of trace data that needs to be recorded and processed. Sometimes developers want to have a way to ensure that a particular trace is going to be recorded (sampled) by the tracing system, e.g. by including a special parameter in the HTTP request, like `debug=true`. The OpenTracing API standardizes around some useful tags, and one o them is the so-called "sampling priority": exact semnatics are implementation-specific, but any values greater than zero (the default) indicates a trace of elevated importance. In order to pass this attribute to tracing systems that rely on pre-trace sampling, the following approach can be used:

```python
if request.get('debug'):
    span = tracer.start_span(
        operation_name=operation,
        tags={tags.SAMPLING_PRIORITY: 1}
    )
```

### Tracing Messaging Scenarios

There are two messaging styles that should be handled, Message Queues and Publish/Subscribe (Topics).

The main distinction between these styles is that a message written to a queue can only be consumed by **at most** one consumer, whereas a message published on a topic can be consumed by zero or more subscribers. The other point to note is that although a message can be sent/published by a producer, that does not guarantee that it will be consumed - messaging systems are asynchronous and therefore the producer has no visibility of when or if the message was delivered.

From a tracing perspective, the messaging style is not important, only that the span context associated with the producer is propagated to the zero or more consumers of the message. It is then the responsibility of the consumer(s) to create a span to encapsulate processing of the consumed message and establish a _FollowsFrom_ reference to the propagated span context.

As with the RPC client example, a messaging producer is expected to start a new tracing Span before sending a message, and propagate the new Span along with that message. The following example shows how it can be done.

```python
def traced_request(message, operation, producer):
    # retrieve current span from propagated message context
    parent_span = get_current_span()

    # start a new span to represent the message producer
    span = tracer.start_span(
        operation_name=operation,
        child_of=parent_span.context,
        tags={'message.destination': message.destination}
    )

    # propagate the Span via message headers
    tracer.inject(
        span.context,
        format=opentracing.TEXT_MAP_FORMAT,
        carrier=message.headers)

    try:
        messaging_client.send(message)
    except Exception e:
        span.log(event='general exception', payload=e)
        span.set_tag('error', true)
        span.finish()
        raise
```

  * The `get_current_span()` function is not a part of the OpenTracing API. It is meant to represent some util method of retrieving the current Span from the current request context propagated implicitly (as is often the case in Python).
  * Because the messaging client may throw an exception, we use a try/catch block to finish the Span in all circumstances, to ensure it is reported and avoid leaking resources.

The following is an example of a message consumer checking whether an incoming message contains a span context. If it does, this will be used to establish a relationship with the message producer's Span.

```python
extracted_context = tracer.extract(
    format=opentracing.TEXT_MAP_FORMAT,
    carrier=message.headers
)
if extracted_context is None:
    span = tracer.start_span(operation_name=operation)
else:
    span = tracer.start_span(operation_name=operation, follows_from=extracted_context)
span.set_tag('message.destination', message.destination)
```

#### Synchronous request response over queues

Although not necessarily used a great deal, some messaging platforms/standards (e.g. JMS) support the ability to provide a _ReplyTo_ destination in the header of a message. When the consumer receives the message it returns a result message to the nominated destination. 

This pattern could be used to simulate a synchronous request/response, in which case the relationship type between the consumer and producer spans should technically be _Child Of_. 

However this pattern could also be used for delegation to indicate a third party that should be informed of the result. In which case it would be treated as two separate message exchanges with _Follows From_ relationship types linking each stage.

As it would be difficult to distinguish between these two scenarios, and the use of message oriented middleware for synchronous request/response pattern should be discouraged, it is recommended that the request/response scenario be ignored from a tracing perspective. 


