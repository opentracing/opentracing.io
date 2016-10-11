# Supported Tracer Implementations

## Appdash

Appdash ([background reading](https://sourcegraph.com/blog/announcing-appdash-an-open-source-perf-tracing/)) is a lightweight, Golang-based distributed tracing system, originally developed and since open-sourced by [sourcegraph](https://sourcegraph.com/). There is an OpenTracing-compatible `Tracer` implementation that uses Appdash as a backend; binding Appdash to OpenTracing instrumentation is trivial:

```go
import (
    "github.com/sourcegraph/appdash"
    appdashtracer "github.com/sourcegraph/appdash/opentracing"
)

func main() {
    // Initialization with a local collector:
    collector := appdash.NewLocalCollector(myAppdashStore)
    chunkedCollector := appdash.NewChunkedCollector(collector)
    tracer := appdashtracer.NewTracer(chunkedCollector)

    // Initialization with a remote collector:
    collector := appdash.NewRemoteCollector("localhost:8700")
    tracer := appdashtracer.NewTracer(collector)
}
```

For more details, read [the godocs](https://godoc.org/github.com/sourcegraph/appdash/opentracing).


## Zipkin

Uber has bound OpenTracing to Zipkin internally, though this work is not public. There is also an [in-progress PR](https://github.com/opentracing/opentracing-java/pull/25) which bridges [Brave](https://github.com/openzipkin/brave) (the most popular Zipkin Java instrumentation library) and OpenTracing, thus making an easy bridge from Zipkin instrumentation into other OpenTracing-compatible Tracers.


## LightStep

[LightStep](http://lightstep.com/) runs a private beta with OpenTracing-native tracers in production environments. There are OpenTracing-compatible [LightStep Tracers](https://github.com/lightstep) available for Go, Python, Javasrcipt, Objective-C, Java, and PHP, with Ruby and C++ in-progress.
