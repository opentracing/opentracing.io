---
title: Getting Started
weight: 1
---

## Hello World examples

Both of these examples assume that Jaeger is running locally via Docker:

```sh
docker run -d -p 5775:5775/udp -p 16686:16686 jaegertracing/all-in-one:latest
```

These can be adapted to use other OpenTracing-compatible Tracer easily by adjusting the initialization code to match the particular implementation.

### Java

Add the Jaeger libraries to your dependencies -

```xml
<dependency>
  <groupId>io.jaegertracing</groupId>
  <artifactId>jaeger-client</artifactId>
  <version>0.32.0</version>
</dependency>
```

```java
import io.jaegertracing.Configuration;
import io.jaegertracing.Configuration.ReporterConfiguration;
import io.jaegertracing.Configuration.SamplerConfiguration;
import io.jaegertracing.internal.JaegerTracer;
import io.jaegertracing.internal.samplers.ConstSampler;
import io.opentracing.Span;
import io.opentracing.util.GlobalTracer;

...

SamplerConfiguration samplerConfig = SamplerConfiguration.fromEnv()
  .withType(ConstSampler.TYPE)
  .withParam(1);

ReporterConfiguration reporterConfig = ReporterConfiguration.fromEnv()
  .withLogSpans(true);

Configuration config = new Configuration("helloWorld")
  .withSampler(samplerConfig)
  .withReporter(reporterConfig);

GlobalTracer.register(config.getTracer());

...

try (Span parent = GlobalTracer.get()
            .buildSpan("hello")
            .start()) {
    try (Span child = GlobalTracer.get()
            .buildSpan("world")
            .asChildOf(parent)
            .start()) {
    }
}
```

### Go

```go
import (
    "github.com/opentracing/opentracing-go"
    "github.com/uber/jaeger-client-go"
    "github.com/uber/jaeger-client-go/config"
)

...

func main() {
    ...
    cfg := config.Configuration{
	Sampler: &config.SamplerConfig{
	    Type:  "const",
	    Param: 1,
	},
	Reporter: &config.ReporterConfig{
	    LogSpans:            true,
	    BufferFlushInterval: 1 * time.Second,
	},
    }
    tracer, closer, err := cfg.New(
        "your_service_name",
        config.Logger(jaeger.StdLogger),
    )
    opentracing.SetGlobalTracer(tracer)
    defer closer.Close()

    someFunction()
    ...
}

...

func someFunction() {
    parent := opentracing.GlobalTracer().StartSpan("hello")
    defer parent.Finish()
    child := opentracing.GlobalTracer().StartSpan(
	"world", opentracing.ChildOf(parent.Context()))
    defer child.Finish()
}
```

## Self-guided Walkthrough Tutorials

### Go

[Take OpenTracing for a HotROD Ride](https://medium.com/opentracing/take-opentracing-for-a-hotrod-ride-f6e3141f7941) involves successive optimizations of a Go-based Ride-on-Demand demonstration service, all informed by tracing data.

### Java

[MicroDonuts](https://github.com/opentracing-contrib/java-opentracing-walkthrough) shows the reader how to get tracing instrumentation added to a multi-service app, and includes properly-configured initialization of several OpenTracing-compatible Tracers.

### Multiple languages

The [OpenTracing Tutorial](https://github.com/yurishkuro/opentracing-tutorial) provides an example combining Go, Java, Python, and Node.js.


