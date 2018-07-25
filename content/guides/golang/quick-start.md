---
title: "Golang: Quick Start"
---

The examples on this page use [Jaeger](https://github.com/jaegertracing/jaeger-client-go)(an OpenTracing comptible tracer). These examples assume that [Jaeger all-in-one image](https://github.com/jaegertracing/jaeger) is running locally via Docker:

`$ docker run -d -p 6831:6831/udp -p 16686:16686 jaegertracing/all-in-one:latest`

These can be adapted to use other OpenTracing-compatible Tracer easily by adjusting the initialization code to match the particular implementation.

## Setting up your tracer

```golang
import (
    "log"
    "os"

    opentracing "github.com/opentracing/opentracing-go"
    "github.com/uber/jaeger-lib/metrics"

    "github.com/uber/jaeger-client-go"
    jaegercfg "github.com/uber/jaeger-client-go/config"
    jaegerlog "github.com/uber/jaeger-client-go/log"
)

...

func main() {
    // Sample configuration for testing. Use constant sampling to sample every trace
    // and enable LogSpan to log every span via configured Logger.
    cfg := jaegercfg.Configuration{
        ServiceName: "your_service_name",
        Sampler:     &jaegercfg.SamplerConfig{
            Type:  jaeger.SamplerTypeConst,
            Param: 1,
        },
        Reporter:    &jaegercfg.ReporterConfig{
            LogSpans: true,
        },
    }

    // Example logger and metrics factory. Use github.com/uber/jaeger-client-go/log
    // and github.com/uber/jaeger-lib/metrics respectively to bind to real logging and metrics
    // frameworks.
    jLogger := jaegerlog.StdLogger
    jMetricsFactory := metrics.NullFactory

    // Initialize tracer with a logger and a metrics factory
    tracer, closer, err := cfg.NewTracer(
        jaegercfg.Logger(jLogger),
        jaegercfg.Metrics(jMetricsFactory),
    )
    // Set the singleton opentracing.Tracer with the Jaeger tracer.
    opentracing.SetGlobalTracer(tracer)
    defer closer.Close()

    // continue main()
}
```

## Start a Trace

```golang
import (
    opentracing "github.com/opentracing/opentracing-go"
)

...

tracer := opentracing.GlobalTracer()

span := tracer.StartSpan("say-hello")
println(helloStr)
span.Finish()
```

## Create a Child Span

```golang
import (
    opentracing "github.com/opentracing/opentracing-go"
)

...

tracer := opentracing.GlobalTracer()

parentSpan := tracer.StartSpan("parent")
defer parentSpan.Finish()

...

// Create a Child Span. Note that we're using the ChildOf option.
childSpan := tracer.StartSpan(
    "child",
    opentracing.ChildOf(parentSpan.Context()),
)
defer childSpan.finish()
```

## Make an HTTP request

To get traces across service boundaries, we propgagte [context](https://golang.org/pkg/context/) by injecting the context into http headers. Once the downstream service recieves the http request, it must extract the context and continue the trace. (The code example doesn't handle errors correctly, please don't do this in production code; this is just an example)

The upstream(client) service:

```golang
import (
    "net/http"

    opentracing "github.com/opentracing/opentracing-go"
    "github.com/opentracing/opentracing-go/ext"
)

...

tracer := opentracing.GlobalTracer()

clientSpan := tracer.StartSpan("client")
defer clientSpan.Finish()

url := "http://localhost:8082/publish"
req, _ := http.NewRequest("GET", url, nil)

// Set some tags on the clientSpan to annotate that it's the client span. The additional HTTP tags are useful for debugging purposes.
ext.SpanKindRPCClient.Set(clientSpan)
ext.HTTPUrl.Set(clientSpan, url)
ext.HTTPMethod.Set(clientSpan, "GET")

// Inject the client span context into the headers
tracer.Inject(clientSpan.Context(), opentracing.HTTPHeaders, opentracing.HTTPHeadersCarrier(req.Header))
resp, _ := http.DefaultClient.Do(req)
```

The downstream(server) service:

```golang
import (
    "log"
    "net/http"

    opentracing "github.com/opentracing/opentracing-go"
    "github.com/opentracing/opentracing-go/ext"
)

func main() {

    // Tracer initialization, etc.

    ...

    http.HandleFunc("/publish", func(w http.ResponseWriter, r *http.Request) {
        // Extract the context from the headers
        spanCtx, _ := tracer.Extract(opentracing.HTTPHeaders, opentracing.HTTPHeadersCarrier(r.Header))
        serverSpan := tracer.StartSpan("server", ext.RPCServerOption(spanCtx))
        defer serverSpan.Finish()
    })

    log.Fatal(http.ListenAndServe(":8082", nil))
}
```

## View your trace

If you have Jaeger all-in-one running, you can view your trace at `localhost:16686`.

## Link to GO walkthroughs / tutorials

* [Take OpenTracing for a HotROD Ride](https://medium.com/opentracing/take-opentracing-for-a-hotrod-ride-f6e3141f7941) involves successive optimizations of a Go-based Ride-on-Demand demonstration service, all informed by tracing data.
* In-depth Self-Guided [Golang Opentracing Tutorial](https://github.com/yurishkuro/opentracing-tutorial/tree/master/go)

