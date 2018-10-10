---
title: "Tracers"
weight: 4
---

#### Setting up your Tracer

A **Tracer** is the actual implementation that will record the **Span**s and publish them somewhere. How your application handles the actual **Tracer** is up to you: either consume it directly throughout your application or store it in the **GlobalTracer** for easier usage with instrumented frameworks.

Different **Tracer** implementations vary in how and what parameters they receive at initialization time, such as:

* Component name for this application's traces.
* Tracing endpoint.
* Tracing credentials.
* Sampling strategy.


For example, initializing the **Tracer** implementation of `Jaeger` might look like this:

```java
  import io.opentracing.Tracer;

  SamplerConfiguration samplerConfig = new SamplerConfiguration("const", 1);
  ReporterConfiguration reporterConfig = new ReporterConfiguration(true, null, null, null, null);
  Configuration config = new Configuration(service, samplerConfig, reporterConfig);

  // Get the actual OpenTracing-compatible Tracer.
  Tracer tracer = config.getTracer();
```

If your **Tracer** supports it, the [TracerResolver](https://github.com/opentracing-contrib/java-tracerresolver) can also be used. With this approach, there's no **Tracer**-specific initialization code in your application:

```java
  Tracer tracer = TracerResolver.resolveTracer();
```

Once a **Tracer** instance is obtained, it can be used to manually create **Span**, or pass it to existing instrumentation for frameworks and libraries:

```java
  // OpenTracing Redis client. It can be *any* OT-compatible tracer.
  Tracer tracer = ...;
  new TracingJedis(tracer);
```

#### Global Tracer

In order to not force the user to keep around a **Tracer**, the **io.opentracing.util** artifact includes a helper **GlobalTracer** class implementing the **io.opentracing.Tracer** interface, which, as the name implies, acts as as a global instance that can be used from anywhere. It works by forwarding all operations to another underlying **Tracer**, that will get registered at some future point.

By default, the underlying **Tracer** is a no-nop implementation.

```java
  import io.opentracing.util.GlobalTracer;

  // As part of initialization, pass it as an actual Tracer
  // to code that will create Spans in the future.
  new TracingJedis(GlobalTracer.get());

  // Eventually register it, so all the calls to GlobalTracer.get()
  // are forwarded to this object. Registration can happen only once.
  Tracer tracer = new CustomTracer(...);
  GlobalTracer.register(tracer);
  ...

  // Create a Span as usually. This Span creation will happen
  // using your CustomTracer.
  Span span = GlobalTracer.get().buildSpan("foo").start();
```

#### Using Tracer specific features

For using **Tracer**-specific features, the instance needs to be casted back to the original type:

```java
  ((CustomTracer)tracer).customFeature(100);
```

**GlobalTracer** does not expose the original **Tracer**, and thus is not possible to use **Tracer**-specific features through it.
