---
title: Guide to Java
---

The Java OpenTracing API lives in https://github.com/opentracing/opentracing-java and closely follows the naming of the components as defined in the specification.

The repository contains four main artifacts:

* `opentracing-api`: the main API. No dependencies.
* `opentracing-noop`: no-op implementation of the interfaces of the main API, which, as the name implies, do nothing. Depends on `opentracing-api`.
* `opentracing-mock`: mock layer for testing. Contains a **MockTracer** that simply saves the **Span**s to memory. Depends on `opentracing-api` and `opentracing.noop`.
* `opentracing-util`: Utility classes, such as a global **Tracer** and a default implementation of **ScopeManager** based on thread-local storage. Depends on all the previous artifacts.

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

The main OpenTracing API declares all the main components as interfaces, which additional helper classes.

* **io.opentracing**: Main package, containing the essential interfaces, such as **Tracer**, **Span**, **SpanContext**, **Scope** and **ScopeManager**.
* **io.opentracing.log**: Package containing helper classes for logging (through **Span.log()**).
* **io.opentracing.propagation**: Package containing interfaces and helper classes for injection and extraction of **SpanContext**, as well as for defining the formats used for it.
* **io.opentracing.tag**: Package containing helper classes for **Span** tags.

Consumers will most of the time consume only this part of the API, with potentially using the `opentracing-mock` artifact for testing.

**Next:** [Quick start](../quick-start/)
