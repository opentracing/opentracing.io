---
title: Tracers
---

## Introduction

OpenTracing provides an open, vendor-neutral standard API for consistent distributed tracing of request across processes, from web and mobile client platforms to the storage and custom backends at the bottom of application. This means that instrumentation would remain the same irrespective of the tracer system being used by the developer. In order to instrument the web application using OpenTracing specification, a compatible OpenTracing tracer must be deployed and listening for incoming span requests. A list of the all the supported tracers is available [here](./../../supported-tracers).

### Tracer Interface

The Tracer interface creates Spans and understands how to Inject (serialize) and Extract (deserialize) them across process boundaries. It has the following capabilities:

- Start a New Span
- Inject a SpanContect into a Carrier
- Extract a SpanContect from a Carrier

Each of these will be discussed in more detail below. For implementation purposes, check out the specific language guide.

### Setting up Tracer

The first step in instrumenting your application with OT specification is setting up the tracer configuration and registering the tracer with GlobalTracer using the `register` method. This step basically indicates the tracer’s endpoint and the service that will send data to the server. The GlobalTracer forwards all the methods to the tracer that has been configured.
The `register()` method can only be called once by the developer in every application during the initialization of a tracer. In case no Global Tracer is registered, the default `NoopTracer` will be used.

### Starting a new Trace
Finally, a new trace can be started by creating a new span. A span must specify the operation name. Operation names are used for providing semantic meaning to the trace. It is important to recognize whether we need to start a new trace or connect with an already-active trace. If there's an active trace, you'll start a span with the active span as its parent. Otherwise, the span you start will have no parent.OpenTracing supports two kinds of direct causal relationships:

1. **ChildOf**: The parent span is dependent on the child span for its execution.
2. **FollowsFrom**: This relationship is used to model asynchronous executions. The parent span is fully independent of the child span.


### Accessing the Active Span
The GlobalTracer can be used to access the currently ActiveSpan and log events. Further, ActiveSpans can be accessed through a scopeManager in some languages. Refer to the specific language guide for more implementation details.

### Propagating a Trace with Inject/Extract
In order to trace across process boundaries in distributed systems, services need to be able to continue the trace injected by the client that sent each request. OpenTracing allows this to happen by providing inject and extract methods that encode a span's context into a carrier.
The inject method allows for the SpanContext to be passed on to a carrier. For example, passing the trace information into the client's request so that the server you send it to can continue the trace. The extract method does the exact opposite. It extract the SpanContext from the carrier. For example, if there was an active request on the client side, the developer must extract the span context using the `io.opentracing.Tracer.extract` method.

## Tracing Systems

The following tracing backends have OpenTracing-compatible tracing libraries:

Tracing System | Supported Languages
------------ | -------------
CNCF Jaeger | [Java](https://github.com/jaegertracing/jaeger-client-java), [Go](https://github.com/jaegertracing/jaeger-client-go), [Python](https://github.com/jaegertracing/jaeger-client-python), [Node.js](https://github.com/jaegertracing/jaeger-client-node), [C++](https://github.com/jaegertracing/cpp-client), [C#](https://github.com/jaegertracing/jaeger-client-csharp)
Appdash | [Go](https://github.com/sourcegraph/appdash)
LightStep | [Go](https://github.com/lightstep/lightstep-tracer-go), [Python](https://github.com/lightstep/lightstep-tracer-python), [Javascript](https://github.com/lightstep/lightstep-tracer-javascript), [Objective-C](https://github.com/lightstep/lightstep-tracer-objc), [Java](https://github.com/lightstep/lightstep-tracer-java), [PHP](https://github.com/lightstep/lightstep-tracer-php), [Ruby](https://github.com/lightstep/lightstep-tracer-ruby), [C++](https://github.com/lightstep/lightstep-tracer-cpp)
Hawkular | [Java](https://github.com/hawkular/hawkular-apm)
Instana | [Crystal](https://github.com/instana/crystal-sensor/blob/master/README.md), [Go](https://github.com/instana/golang-sensor/blob/master/README.md), [Java](https://github.com/instana/instana-java-opentracing/blob/master/README.md), [Node.js](https://github.com/instana/nodejs-sensor/blob/master/README.md), [Python](https://github.com/instana/python-sensor/blob/master/README.md), [Ruby](https://github.com/instana/ruby-sensor/blob/master/README.md)
inspectIT | [Java](https://github.com/inspectIT/inspectIT)
stagemonitor | [Java](https://github.com/stagemonitor/stagemonitor)
Datadog | [Go](https://github.com/DataDog/dd-opentracing-go)
