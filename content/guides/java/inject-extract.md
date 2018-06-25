---
title: "Java: Inject and Extract"
---

## Introduction

In order to trace across process boundaries and RPC calls in distributed systems, span context needs to propagated over the wire. The Java Opentracing API provides two functions in the Tracer interface to do just that, `inject(SpanContext, format, carrier)` and `extract(format, carrier)`.

## Format Options and Carriers
The **format** parameter refers to one of the three standard encodings the OpenTracing API defines:

1. `TEXT_MAP` where span context is encoded as a collection of string key-value pairs,
2. `BINARY` where span context is encoded as an opaque byte array,
3. `HTTP_HEADERS`, which is similar to `TEXT_MAP` except that the keys must be safe to be used as HTTP headers.

The **carrier** is an abstraction over the underlying RPC framework. For example, a carrier for `TEXT_MAP` format is an interface that allows the tracer to write key-value pairs via `put(key, value)` method, while a carrier for Binary format is simply a ByteBuffer.

## Injecting and Extracting HTTP
The following section discusses injecting and extracting a span's context over HTTP requests.
#### Injecting the Span’s Context to HTTP
In order to pass a span’s context over the HTTP request, the developer needs to call the `tracer.inject` before building the HTTP request, like so:

```java
Tags.SPAN_KIND.set(tracer.activeSpan(), Tags.SPAN_KIND_CLIENT);
Tags.HTTP_METHOD.set(tracer.activeSpan(), "GET");
Tags.HTTP_URL.set(tracer.activeSpan(), url.toString());
tracer.inject(tracer.activeSpan().context(), Format.Builtin.HTTP_HEADERS, new RequestBuilderCarrier(requestBuilder));
```
Notice that a couple additional tags have been added to the `span` with some metadata about the HTTP request, following the OpenTracing Semantic Conventions.
In this case the `carrier` is HTTP request headers object, which can be adapted to the carrier API by wrapping it in a helper class as follows:
```java
public class RequestBuilderCarrier implements io.opentracing.propagation.TextMap {
    private final Request.Builder builder;

    RequestBuilderCarrier(Request.Builder builder) {
        this.builder = builder;
    }

    @Override
    public Iterator<Map.Entry<String, String>> iterator() {
        throw new UnsupportedOperationException("carrier is write-only");
    }

    @Override
    public void put(String key, String value) {
        builder.addHeader(key, value);
    }
}
```
#### Extracting the Span’s Context from Incoming Request

The logic on the client side instrumentation is similar, the only difference is that `tracer.extract` is used and the span is tagged as `span.kind=server`.

```java
public static Scope startServerSpan(Tracer tracer, javax.ws.rs.core.HttpHeaders httpHeaders,
        String operationName) {
    // format the headers for extraction
    MultivaluedMap<String, String> rawHeaders = httpHeaders.getRequestHeaders();
    final HashMap<String, String> headers = new HashMap<String, String>();
    for (String key : rawHeaders.keySet()) {
        headers.put(key, rawHeaders.get(key).get(0));
    }

    Tracer.SpanBuilder spanBuilder;
    try {
        SpanContext parentSpan = tracer.extract(Format.Builtin.HTTP_HEADERS, new TextMapExtractAdapter(headers));
        if (parentSpan == null) {
            spanBuilder = tracer.buildSpan(operationName);
        } else {
            spanBuilder = tracer.buildSpan(operationName).asChildOf(parentSpan);
        }
    } catch (IllegalArgumentException e) {
        spanBuilder = tracer.buildSpan(operationName);
    }
    return spanBuilder.withTag(Tags.SPAN_KIND.getKey(), Tags.SPAN_KIND_SERVER).startActive(true);
}
```

In the above example, instead of using a dedicated adapter class to convert JAXRS `HttpHeaders` type into `io.opentracing.propagation.TextMap`, the headers are copied to a plain `HashMap<String, String>` and converted using a standard adapter `TextMapExtractAdapter`.

## Injecting and Extracting TextMap
The process of injecting and extracting `TextMap` is similar to that of HTTP. Given below are some elaborated code examples of injecting and extracting tracing information using `TextMap` format.

```java
protected void attachTraceInfo(Tracer tracer, Span span, final Invocation inv) {
    tracer.inject(span.context(), Format.Builtin.TEXT_MAP, new TextMap() {

        @Override
        public void put(String key, String value) {
            inv.getAttachments().put(key, value);
        }

        @Override
        public Iterator<Map.Entry<String, String>> iterator() {
            throw new UnsupportedOperationException("TextMapInjectAdapter should only be used with Tracer.inject()");
        }
    });
}
```
The above method injects the invocation information into the span’s context on the consumer side. The `TextMap` interface has been implemented to create a `TextMap` of invocation attachments.

```java
protected Span extractTraceInfo(Tracer tracer, Invoker<?> invoker, Invocation inv) {

    Tracer.SpanBuilder span = tracer.buildSpan(“Operation_Name_Here”);
    try {
        SpanContext spanContext = tracer.extract(Format.Builtin.TEXT_MAP, new TextMapExtractAdapter(inv.getAttachments()));
        if (spanContext != null) {
            //if spanContext is extracted, the spanContext is propagated to the new span

            span.asChildOf(spanContext);
        }
    } catch (Exception e) {
        span.withTag("Error", "extract from request fail, error msg:" + e.getMessage());
    }
    return span.startManual();
}
```
On the provider side, `tracer.extract()` is used to extract the invocation attachments. The logic is similar to `tracer.inject()`.



## Injecting and Extracting Binary
Binary format is used for injecting/extracting span context encoded in an opaque byte array. Opaque means that the inner representation of the array is not known.

Injecting and extracting binary can be implemented as follows:

```java
//Inject binary
public void byteBufferInjection() throws Exception {
  byte[] key = "foo".getBytes(ByteBufferContext.CHARSET), value = "bar".getBytes(ByteBufferContext.CHARSET);
  ByteBuffer byteBuffer = ByteBuffer.allocate(2 + 2 * 4 + key.length + value.length);
  tracer.inject(spanContext, Format.Builtin.BINARY, byteBuffer);

}

//Extract binary
public void byteBufferExtraction(ByteBuffer byteBuffer) throws Exception {
  SpanContext spanContext = tracer.extract(Format.Builtin.BINARY, byteBuffer);
  //do something with spanContext...

}
```
