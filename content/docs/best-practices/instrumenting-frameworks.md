---
title: Instrumenting frameworks
---

*Trace all the things!*

## Audience

The audience for this guide are developers interested in adding [OpenTracing](http://opentracing.io/) instrumentation to a web, RPC, or other framework that makes requests and/or receives responses. This instrumentation makes it easy for developers using the framework to incorporate end-to-end (distributed) tracing.

Distributed tracing provides insight about individual requests as they propagate throughout a system. OpenTracing is an open-source standard API for consistent distributed tracing of requests across processes, from web and mobile client platforms to the storage systems and custom backends at the bottom of an application stack. Once OpenTracing integrates across  the entire application stack, it’s easy to trace requests across the distributed system. This allows developers and operators much-needed visibility to optimize and stabilize production services.

Before you begin, check [here](/pages/api/api-implementations) to make sure that there's a working OpenTracing API for your platform.

## Overview

At a high level, here is what you need for an OpenTracing integration:

Server framework requirements:

* Filters, interceptors, middleware, or another way to process inbound requests
* Active span storage: either a request context or a request-to-span map
* Settings or another way to configure tracer configuration

Client framework requirements:

* Filters, interceptors, or another way to process outgoing requests
* Settings or another way to configure tracing configuration

## Pro-tips:

Before we dive into implementation, here are a few important concepts and features that should be made available to framework users.

### Operation Names

You'll notice an operation_name variable floating around this tutorial. Every span is created with an operation name that should follow the guidelines outlined [here](/pages/spec). You should have a default operation name for each span, but also provide a way for the user to specify custom operation names.

Examples of default operation names:

* The name of the request handler method
* The name of a web resource
* The concatenated names of an RPC service and method

### Specifying Which Requests to Trace

Some users may want to trace every request while other may want only specific requests to be traced. You should ideally allow users to set up tracing for either of these scenarios. For example, you could provide @Trace annotations/decorators, in which only annotated handler functions have tracing enabled. You can also provide settings for the user to specify whether they're using these annotations, versus whether they want all requests to be traced automatically.

### Tracing Request Properties

Users may also want to track information about the requests without having to manually access the span and set the tags themselves. It's helpful to provide a way for users to specify properties of the request they want to trace, and then automatically trace these features. Ideally, this would be similar to the Span Decorator function in gRPC:

```
// SpanDecorator binds a function that decorates gRPC Spans.
func SpanDecorator(decorator SpanDecoratorFunc) Option {
	return func(o *options) {
		o.decorator = decorator
	}
}
```

Another approach could have a setting `TRACED_REQUEST_ATTRIBUTES` that the user can pass a list of attributes (such as `URL`, `METHOD`, or `HEADERS`), and then in your tracing filters, you would include the following:

```
for attr in settings.TRACED_REQUEST_ATTRIBUTES:
    if hasattr(request, attr):
        payload = str(getattr(request, attr))
        span.set_tag(attr, payload)
```

## Server-side Tracing

The goals of server-side tracing are to trace the lifetime of a request to a server and connect this instrumentation to any pre-existing trace in the client. You can do this by creating spans when the server receives the request and ending the span when the server finishes processing the request. The workflow for tracing a server request is as follows:

* Server Receives Request
    * Extract the current trace state from the inter-process transport (HTTP, etc)
    * Start the span
    * Store the current trace state
* Server Finishes Processing the Request / Sends Response
    * Finish the span

Because this workflow depends on request processing, you'll need to know how to  change the  framework’s requests and responses handling--whether this is through filters, middleware, a configurable stack, or some other mechanism.

### Extract the Current Trace State

In order to trace across process boundaries in distributed systems, services need to be able to continue the trace injected by the client that sent each request. OpenTracing allows this to happen by providing inject and extract methods that encode a span's context into a carrier. (The specifics of the encoding is left to the implementor, so you won't have to worry about that.)

If there was an active request on the client side, the span context will already be injected into the the request. Your job is to then extract that span context using the io.opentracing.Tracer.extract method. The carrier that you'll extract from depends on which type of service you're using; web servers, for example, use HTTP headers as the carrier for HTTP requests (as shown below):

Python:

```Python
span_ctx = tracer.extract(opentracing.Format.HTTP_HEADERS, request.headers)
```

Java:

```Java
import io.opentracing.propagation.Format;
import io.opentracing.propagation.TextMap;

Map<String, String> headers = request.getHeaders();
SpanContext parentSpan = tracer.getTracer().extract(Format.Builtin.HTTP_HEADERS,
    new TextMapExtractAdapter(headers));
```

OpenTracing can throw errors when an extract fails due to no span being present, so make sure to catch the errors that signify there was no injected span and not crash your server. This often just means that the request is coming from a third-party (or untraced) client, and the server should start a new trace.

### Start the span

Once you receive a request and extract any existing span context, you should immediately start a span representing the lifetime of the request to the server. If there is an extracted span context present, then the new server span should be created with a ChildOf reference to the extracted span, signifying the relationship between the client request and server response. If there was no injected span, you'll just start a new span with no references.

Python:

```Python
if(extracted_span_ctx):
    span = tracer.start_span(operation_name=operation_name,
        child_of=extracted_span_ctx)
else:
    span = tracer.start_span(operation_name=operation_name)
```

Java:

```Java
if(parentSpan == null){
    span = tracer.buildSpan(operationName).start();
} else {
    span = tracer.buildSpan(operationName).asChildOf(parentSpan).start();
}
```

### Store the current span context

It's important for users to be able to access the current span context while processing a request, in order to set custom tags on the span, log events, or create child spans that represent work done on behalf of the server. In order to allow for this, you have to decide how to make the span available to users. This will be dictated largely by the structure of your framework. Here are  two common cases as examples:

1. Use of request context: If your framework has a request context that can store arbitrary values, then you can store the current span in the request context for the duration of the processing of a request. This works particularly well if your framework has filters that can alter how requests are processed. For example, if you have a request context called ctx, you could apply a filter similar to this:

```
def filter(request):
    span = # extract / start span from request
    with (ctx.active_span = span):
        process_request(request)
    span.finish()
```

3. Now, at any point during the processing of the request, if the user accesses `ctx.active_span`, they'll receive the span for that request. Note that once the request is processed, `ctx.active_span` should retain whatever value it had before the request was processed.

4. Map Requests to their associated span: You may not have a request context available, or you may use filters that have separate methods for preprocessing and postprocessing requests. If this is the case, you can instead create a mapping of requests to the span that represents its lifetime. One way that you could do this is to create a framework-specific tracer wrapper that stores this mapping. For example:

```
class MyFrameworkTracer:
    def __init__(opentracing_tracer):
        self.internal_tracer = opentracing_tracer
        self.active_spans = {}
    def add_span(request, span):
        self.active_spans[request] = span
    def get_span(request):
        return self.active_spans[request]
    def finish_span(request):
        span = self.active_spans[request]
        span.finish()
        del self.active_spans[request]
```

5. If your server can handle multiple requests at once, then make sure that your implementation of the span map is threadsafe.

6. The filters would then be applied along these lines:

```
def process_request(request):
    span = # extract / start span from request
    tracer.add_span(request, span)
def process_response(request, response):
    tracer.finish_span(request)
```

7. Note that the user here can call `tracer.get_span(request)` during response processing to access the current span. Make sure that the request (or whatever unique request identifier you're using to map to spans) is availabe to the user.

## Client-side tracing

Enabling Client-side tracing is applicable to frameworks that have a client component that is able to initiate a request. The goal is to inject a span into the header of the request that can then be passed to the server-side portion of the framework. Just like with server-side tracing, you'll need to know how to alter how your clients send requests and receive responses. When done correctly, the trace of a request is visible end-to-end.

Workflow for client side tracing:

* Prepare request
    * Load the current trace state
    * Start a span
    * Inject the span into the request
* Send request
* Receive response
    * Finish the span

### Load the Current Trace State / Start a Span

Just like on the server side, we have to recognize whether we need to start a new trace or connect with an already-active trace. For instance, most microservices act as both client *and* server within the larger distributed system, and their outbound client requests should be associated with whatever request the service was handling at the time. If there's an active trace, you'll start a span for the client request with the active span as its parent. Otherwise, the span you start will have no parent.

How you recognize whether there is an active trace depends on how you're storing active spans. If you're using a request context, then you can do something like this:

```
if hasattr(ctx, active_span):
    parent_span = getattr(ctx, active_span)
    span = tracer.start_span(operation_name=operation_name,
        child_of=parent_span)
else:
    span = tracer.start_span(operation_name=operation_name)
```

If you're using the request-to-span mapping technique, your approach might look like:

```
parent_span = tracer.get_span(request)
span = tracer.start_span(
    operation_name=operation_name,
    child_of=parent_span)
```

You can see examples of this approach in [gRPC](https://github.com/grpc-ecosystem/grpc-opentracing/blob/master/java/src/main/java/io/opentracing/contrib/ActiveSpanSource.java) and [JDBI](https://github.com/opentracing-contrib/java-jdbi/blob/9f6259538a93f466f666700e3d4db89526eee23a/src/main/java/io/opentracing/contrib/jdbi/OpenTracingCollector.java#L153).

### Inject the Span

This is where you pass the trace information into the client's request so that the server you send it to can continue the trace. If you're sending an HTTP request, then you'll just use the HTTP headers as your carrier.

span = # start span from the current trace state
`tracer.inject(span, opentracing.Format.HTTP_HEADERS, request.headers)`

### Finish the Span

When you receive a response, you want to end the span to signify that the client request is finished. Just like on the server side, how you do this depends on how your client request/response processing happens. If your filter wraps the request directly you can just do this:

```
def filter(request, response):
    span = # start span from the current trace state
    tracer.inject(span, opentracing.Format.HTTP_HEADERS, request.headers)
    response = send_request(request)
    if response.error:
       span.set_tag(opentracing., true)
    span.finish()
```

Otherwise, if you have ways to process the request and response separately, you might extend your tracer to include a mapping of client requests to spans, and your implementation would look more like this:

```
def process_request(request):
    span = # start span from the current trace state
    tracer.inject(span. opentracing.Format.HTTP_HEADERS, request.headers)
    tracer.add_client_span(request, span)
def process_response(request, response):
    tracer.finish_client_span(request)
```

## Closing Remarks

If you'd like to highlight your project as OpenTracing-compatible, feel free to use our GitHub badge and link it to the OpenTracing website.

[![OpenTracing Badge](https://img.shields.io/badge/OpenTracing-enabled-blue.svg)](http://opentracing.io)

`[![OpenTracing Badge](https://img.shields.io/badge/OpenTracing-enabled-blue.svg)](http://opentracing.io)`

Once you've packaged your implementation, email us at [community@opentracing.io](mailto://community@opentracing.io) with your implementation details (platform, description, github username) and we'll create a repo for you under [opentracing-contrib](https://github.com/opentracing-contrib/), so that others will be able to find and use your integration. You can also find there concrete examples of OpenTracing integrations into different open source projects.

If you're interested in learning more about OpenTracing, join the conversation by joining our [mailing list](https://groups.google.com/forum/#!forum/opentracing) or [Gitter](https://gitter.im/opentracing/public).
