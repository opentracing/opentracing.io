---
layout: page
title: APIs and Implementations
---

# Integration APIs

OpenTracing APIs are **available** for the following platforms:

* Go ([1.0RC](#v1rc)) - [https://github.com/opentracing/opentracing-go](https://github.com/opentracing/opentracing-go)
* Python ([1.0RC](#v1rc)) - [https://github.com/opentracing/opentracing-python](https://github.com/opentracing/opentracing-python)
* Javascript ([1.0RC](#v1rc)) - [https://github.com/opentracing/opentracing-javascript](https://github.com/opentracing/opentracing-javascript)
* Objective-C - ([1.0RC](#v1rc)) - [https://github.com/opentracing/opentracing-objc](https://github.com/opentracing/opentracing-objc)
* Java - ([1.0RC](#v1rc)) - [https://github.com/opentracing/opentracing-java](https://github.com/opentracing/opentracing-java)

OpenTracing APIs are **in progress** for the following platforms:

* C++ - [https://github.com/lookfwd/opentracing-cpp/pull/1](https://github.com/lookfwd/opentracing-cpp/pull/1)
* PHP - link forthcoming
* Ruby - link forthcoming

Please refer to the README files in the respective per-platform repositories for usage examples.

Community contributions are welcome for other languages at any time.

<div id="v1rc"></div>

### What does "1.0RC" mean?

It means that the contributors have spent a while thinking through the APIs from above and below, prototyped bindings to several tracing systems and many calling contexts, and have converged on semantics for the various OpenTracing platform APIs.

1.0RC means that we feel comfortable formally binding OpenTracing to production tracing systems and production application code: not just in dev branches, but in public PRs. Once those bindings have been vetted in real production environments (and any adjustments or additions made to OpenTracing as a result) we will announce OpenTracing 1.0 proper.

# Supported Tracer Implementations

## Appdash ([github.com/sourcegraph/appdash](https://github.com/sourcegraph/appdash/blob/master/README.md))

Appdash ([background reading](https://sourcegraph.com/blog/announcing-appdash-an-open-source-perf-tracing/)) is a lightweight, Golang-based distributed tracing system, originally developed and since open-sourced by [sourcegraph](https://sourcegraph.com/). There is an OpenTracing-compatible `Tracer` implementation that uses Appdash as a backend; binding Appdash to OpenTracing instrumentation is trivial:

{% highlight go %}
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
{% endhighlight %}

For more details, read [the godocs](https://godoc.org/github.com/sourcegraph/appdash/opentracing).

## Zipkin ([zipkin.io](http://zipkin.io/))

Uber has bound OpenTracing to its Zipkin-compatible tracing system, Jaeger. Tracer implementations are available for [Go](https://github.com/uber/jaeger-client-go), [Python](https://github.com/uber/jaeger-client-python), and [Java](https://github.com/uber/jaeger-client-java).

The OpenZipkin project also has its own OpenTracing-Zipkin bindings for [Go](https://github.com/openzipkin/zipkin-go-opentracing).

## LightStep ([lightstep.com](http://lightstep.com/))

[LightStep](http://lightstep.com/) runs a private beta with OpenTracing-native tracers in production environments. There are OpenTracing-compatible [LightStep Tracers](https://github.com/lightstep) available for Go, Python, Javasrcipt, Objective-C, Java, and PHP, with Ruby and C++ in-progress.

## Tracer ([github.com/tracer/tracer](https://github.com/tracer/tracer))

The aptly-named "Tracer" tracer is a Dapper-style tracing system written in Go. The OpenTracing bindings are [here](https://github.com/tracer/tracer).
