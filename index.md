---
layout: page
title: Home
---
# The OpenTracing Project

<p class="lead">{{ site.description }}</p>

## Why Tracing?

Developers and engineering organizations are trading in old, monolithic systems for modern microservice architectures, and they do so for numerous compelling reasons: system components scale independently, dev teams stay small and agile, deployments are continuous and decoupled, and so on.

That said, **once a production system contends with real concurrency or splits into many services, crucial (and formerly easy) tasks become difficult**: user-facing latency optimization, root-cause analysis of backend errors, communication about distinct pieces of a now-distributed system, etc.

Contemporary distributed tracing systems (e.g., Zipkin, Dapper, HTrace, X-Trace, among others) aim to address these issues, but they do so via application-level instrumentation using incompatible APIs. Developers are uneasy about tightly coupling their polyglot systems to any particular distributed tracing implementation, yet the application-level instrumentation APIs for these many distinct tracing systems have remarkably similar semantics.

## Why OpenTracing?

Enter **OpenTracing**: by offering consistent, expressive, vendor-neutral APIs for popular platforms, OpenTracing makes it easy for developers to add (or switch) tracing implementations with an `O(1)` configuration change. OpenTracing also offers a lingua franca for OSS instrumentation and platform-specific tracing helper libraries.  Please refer to the [Semantic Specification]({{ baseurl }}spec).

### Language Support

The OpenTracing project aims to provide APIs for all popular platforms. The APIs have standard semantic capabilities and must not be tightly coupled to any particular downstream tracing or monitoring system. Initial target languages are Go, Python, Java, and Javascript, with more to follow.

Please refer to the [Per-Platform APIs]({{ baseurl }}integration) page for the list of currently supported platforms.

## Support or Contact
* Open an issue against [one of the repositories](https://github.com/opentracing), or
* Start a discussion in the [Distributed Tracing](https://groups.google.com/forum/#!forum/distributed-tracing) Google group, or
* Ask a question in the chat room https://gitter.im/opentracing/public

