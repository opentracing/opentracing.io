---
title: Supported tracers
---

## CNCF Jaeger

[Jaeger \\ˈyā-gər\\ ](https://jaegertracing.io) is a distributed tracing system, originally open sourced by [Uber Technologies](https://eng.uber.com/distributed-tracing/). It provides distributed context propagation, distributed transaction monitoring, root cause analysis, service dependency analysis, and performance / latency optimization. Built with OpenTracing support from inception, Jaeger includes OpenTracing client libraries in several languages, including [Java](https://github.com/jaegertracing/jaeger-client-java), [Go](https://github.com/jaegertracing/jaeger-client-go), [Python](https://github.com/jaegertracing/jaeger-client-python), [Node.js](https://github.com/jaegertracing/jaeger-client-node), [C++](https://github.com/jaegertracing/cpp-client) and [C#](https://github.com/jaegertracing/jaeger-client-csharp). It is a [Cloud Native Computing Foundation](https://www.cncf.io/) member project.


## LightStep

[LightStep](http://lightstep.com/) operates a SaaS solution with OpenTracing-native tracers in production environments. There are OpenTracing-compatible [LightStep Tracers](https://github.com/lightstep) available for Go, Python, Javascript, Objective-C, Java, PHP, Ruby, and C++.


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

## Wavefront by VMware

[Wavefront](https://wavefront.com/) is a cloud-native monitoring and analytics platform that provides three dimensional microservices observability with metrics, histograms and OpenTracing-compatible [distributed tracing](https://www.wavefront.com/wavefront-enhances-application-observability-with-distributed-tracing/). With minimal code change, developers can now visualize, monitor and analyze key health performance metrics and distributed traces of [Java](https://github.com/wavefrontHQ/wavefront-opentracing-sdk-java), [Python](https://github.com/wavefrontHQ/wavefront-opentracing-sdk-python) and [.NET](https://github.com/wavefrontHQ/wavefront-opentracing-sdk-csharp) applications built on common frameworks such as Dropwizard and gRPC. Check out the distributed tracing demo [here](https://www.youtube.com/watch?v=mKRuhqJndpw&feature=youtu.be). 


