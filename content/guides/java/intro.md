---
title: Guide to Java
---

The [OpenTracing Java API](https://github.com/opentracing/opentracing-java) lives and closely follows the naming of the components as defined in the specification.

The repository contains four main artifacts:

* `opentracing-api`: the main API. No dependencies.
* `opentracing-noop`: no-op implementation of the interfaces of the main API, which, as the name implies, do nothing. Depends on `opentracing-api`.
* `opentracing-mock`: mock layer for testing. Contains a **MockTracer** that simply saves the **Span**s to memory. Depends on `opentracing-api` and `opentracing.noop`.
* `opentracing-util`: Utility classes, such as the **GlobalTracer** and a default implementation of **ScopeManager** based on thread-local storage. Depends on all the previous artifacts.

An additional artifact exists for testing and trying out new features of the API, called `opentracing-testbed`, which can be used when developing the main API, but otherwise of no use for the OpenTracing consumers.

More information on the classes contained in each artifact below.

#### Installation

Packages exist for `Maven` and `Gradle`, which can be installed as follows:

`Maven`:
```xml
<dependency>
    <groupId>io.opentracing</groupId>
    <artifactId>opentracing-api</artifactId>
    <version>VERSION</version>
</dependency>
```

`Gradle`:
```
compile group: 'io.opentracing', name: 'opentracing-api', version: 'VERSION'
```

Replace `opentracing-api` with the `opentracing-noop`, `opentracing-mock` or `opentracing-util` to install the remaining artifacts. When installing more than one artifact, provide the same **VERSION** for all of them to avoid deployment being broken.

#### Main API

The main [OpenTracing API](http://javadoc.io/doc/io.opentracing/opentracing-api/0.31.0) declares all the main components as interfaces, which additional helper classes, such as **Tracer**, **Span**, **SpanContext**, **Scope**, **ScopeManager** and **Format** (used to define common **SpanContext** extraction/injection formats).

Consumers will most of the time consume only this part of the API, with potentially using the `opentracing-mock` artifact for testing and `opentracing-util` for utility classes.

#### Opentracing Contrib.

Besides the official API, there are also several libraries under [opentracing-contrib](https://github.com/opentracing-contrib), including generic helpers like the [TracerResolver](https://github.com/opentracing-contrib/java-tracerresolver) and framework instrumentation libraries, such as [Java Web Servlet Filter](https://github.com/opentracing-contrib/java-web-servlet-filter) and [Spring Cloud](https://github.com/opentracing-contrib/java-spring-cloud).

#### Quick Start

An easy way to get quickly started, and get familiar with the API is to use **io.opentracing.mock.MockTracer** to create **Span**s and inspect them afterwards, as the resulting **MockSpan**s will expose a lot of information that a normal **Span** would not.

```java
  import java.util.Map;
  import io.opentracing.mock.MockTracer;
  import io.opentracing.mock.MockSpan;
  import io.opentracing.tags.Tags;

  // Initialize MockTracer with the default values.
  MockTracer tracer = new MockTracer();

  // Create a new Span, representing an operation.
  MockSpan span = tracer.buildSpan("foo").start();

  // Add a tag to the Span.
  span.setTag(Tags.COMPONENT, "my-own-application");

  // Finish the Span.
  span.finish();

  // Analize the saved Span.
  System.out.println("Operation name = " + span.operationName());
  System.out.println("Start = " + span.startMicros());
  System.out.println("Finish = " + span.finishMicros());

  // Inspect the Span's tags.
  Map<String, Object> tags = span.tags();
```
