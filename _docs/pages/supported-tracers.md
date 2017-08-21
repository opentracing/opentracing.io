# Supported Tracer Implementations

## Zipkin

[Zipkin](http://zipkin.io/) supports OpenTracing in various languages via community contributions. There is an experimental [bridge from Brave (Zipkin Java) instrumentation to OpenTracing](https://github.com/openzipkin/brave-opentracing) and a [Go implementation zipkin-go-opentracing](https://github.com/openzipkin/zipkin-go-opentracing). Some of Jaeger's client libraries (see below) can be configured to be compatible with Zipkin backend and wire format.

## Jaeger

[Jaeger \\ˈyā-gər\\](http://uber.github.io/jaeger) is Uber's distributed tracing system, built with OpenTracing support from inception. Jaeger includes OpenTracing client libraries in several languages: [Java](https://github.com/uber/jaeger-client-java), [Go](https://github.com/uber/jaeger-client-go), [Python](https://github.com/uber/jaeger-client-python), and [Node.js](https://github.com/uber/jaeger-client-node).


## Appdash

Appdash ([background reading](https://sourcegraph.com/blog/announcing-appdash-an-open-source-perf-tracing/)) is a lightweight, Golang-based distributed tracing system, originally developed and since open-sourced by [sourcegraph](https://sourcegraph.com/). There is an OpenTracing-compatible `Tracer` implementation that uses Appdash as a backend.

For more details, read [the godocs](https://godoc.org/github.com/sourcegraph/appdash/opentracing).


## LightStep

[LightStep](http://lightstep.com/) runs a private beta with OpenTracing-native tracers in production environments. There are OpenTracing-compatible [LightStep Tracers](https://github.com/lightstep) available for Go, Python, Javascript, Objective-C, Java, PHP, Ruby, and C++.


## Hawkular

[Hawkular APM](http://www.hawkular.org/hawkular-apm/) supports OpenTracing-Java and has plans to support other platforms in the near future.


## Instana

[Instana](https://www.instana.com) provides an APM solution supporting OpenTracing in 
[Crystal](https://github.com/instana/crystal-sensor/blob/master/README.md),
[Go](https://github.com/instana/golang-sensor/blob/master/README.md), [Java](https://github.com/instana/instana-java-opentracing/blob/master/README.md), [Node.js](https://github.com/instana/nodejs-sensor/blob/master/README.md),
[Python](https://github.com/instana/python-sensor/blob/master/README.md) and
[Ruby](https://github.com/instana/ruby-sensor/blob/master/README.md). The Instana OpenTracing tracers are interoperable with the other Instana out of the box tracers for .Net, Crystal, Java, Scala, NodeJs, PHP, Python and Ruby.

## sky-walking

[sky-walking](https://github.com/wu-sheng/sky-walking) is an open-source tracer in Java, based on auto-instrumentation mechanism. Support OpenTracing-Java by [sky-walking application toolkit](https://github.com/wu-sheng/sky-walking/wiki/sky-walking-application-toolkit).

## inspectIT

[inspectIT](http://www.inspectit.rocks) aims to be an End-to-End APM solution for Java with support for OpenTracing. The instrumentation capability allows to set up inspectIT in no time with an extensive support for different frameworks and application servers. For more information, take a look at the [documentation](https://inspectit-performance.atlassian.net/wiki/spaces/DOC).

## stagemonitor
[Stagemonitor](http://www.stagemonitor.org/) is an open-source tracing, profiling and metrics solution for Java applications. It uses byte code manipulation to automatically trace your application without code changes. Stagemonitor is compatible with various OpenTracing implementations and can report to multiple back-ends like [Elasticsearch](https://www.elastic.co/products/elasticsearch) and [Zipkin](http://zipkin.io/). It also tracks metrics, like response time and error rates.
