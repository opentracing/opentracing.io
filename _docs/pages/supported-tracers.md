# Supported Tracer Implementations

## CNCF Jaeger

[Jaeger \\ˈyā-gər\\](https://jaegertracing.io) is a distributed tracing system, originally open sourced by [Uber Technologies](https://eng.uber.com/distributed-tracing/). It provides distributed context propagation, distributed transaction monitoring, root cause analysis, service dependency analysis, and performance / latency optimization. Built with OpenTracing support from inception, Jaeger includes OpenTracing client libraries in several languages, including [Java](https://github.com/uber/jaeger-client-java), [Go](https://github.com/uber/jaeger-client-go), [Python](https://github.com/uber/jaeger-client-python), [Node.js](https://github.com/uber/jaeger-client-node), and [C++](https://github.com/jaegertracing/cpp-client). It is a [Cloud Native Computing Foundation](https://www.cncf.io/) member project.


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

## Apache SkyWalking

[Apache SkyWalking](https://github.com/apache/incubator-skywalking) is an APM (application performance monitor) tool for distributed systems, specially designed for microservices, cloud native and container-based (Docker, K8s, Mesos) architectures. Underlying technology is a distributed tracing system. The SkyWalking javaagent is interoperable with OpenTracing-java APIs.

## inspectIT

[inspectIT](http://www.inspectit.rocks) aims to be an End-to-End APM solution for Java with support for OpenTracing. The instrumentation capability allows to set up inspectIT in no time with an extensive support for different frameworks and application servers. For more information, take a look at the [documentation](https://inspectit-performance.atlassian.net/wiki/spaces/DOC).

## stagemonitor
[Stagemonitor](http://www.stagemonitor.org/) is an open-source tracing, profiling and metrics solution for Java applications. It uses byte code manipulation to automatically trace your application without code changes. Stagemonitor is compatible with various OpenTracing implementations and can report to multiple back-ends like [Elasticsearch](https://www.elastic.co/products/elasticsearch) and [Zipkin](http://zipkin.io/). It also tracks metrics, like response time and error rates.

## Datadog
[Datadog APM](https://www.datadoghq.com/apm/) supports OpenTracing, and aims to provide [OpenTracing-compatible tracers](https://www.datadoghq.com/blog/opentracing-datadog-cncf/) for all supported languages.
