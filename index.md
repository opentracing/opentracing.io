---
layout: page
title: Home
---
<h1 class="page-title">Welcome to the OpenTracing API Project</h1>

This page is unfinished; please contact the authors directly if you have questions or would like to contribute.

### Objectives
Numerous organizations recognize the need to propagate a trace context throughout their (distributed) polyglot systems, including web and mobile clients. Designing these instrumentation libraries is subtle, and nobody wants to absorb the front-loaded cost of adding instrumentation only to be tightly coupled to a particular tracing implementation.

The OpenTracing project provides a multi-lingual standard for application-level instrumentation that's loosely coupled to any particular downstream tracing or monitoring system. In this way, adding or switching tracing implementations becomes an O(1) code change.

There is [a slightly-out-of-date initial proposal](https://paper.dropbox.com/doc/Distributed-Context-Propagation-RGvlvD1NFKYmrJG9vGCES) that led directly to OpenTracing.

### Language Support

The OpenTracing project aims to provide APIs for all popular platforms. The APIs have standard semantic capabilities and must not be tightly coupled to any particular downstream tracing or monitoring system (Zipkin, etc). Our initial target languages are Go, Python, Java, and Javascript, with more to follow.

Please refer to the [APIs]({{ baseurl }}apis) page for the list of currently available APIs.

## Authors and Contributors 
(in alphabetical order)

* Adrian Cole (@adriancole)
* Ben Sigelman (@bensigelman)
* Stephen Gutekanst (@slimsag)
* Yuri Shkuro (@yurishkuro)

## Support or Contact
* Open an issue against one of the repositories, or
* Start a discussion in the [Distributed Tracing](https://groups.google.com/forum/#!forum/distributed-tracing) Google group, or
* Ask a question in the chat room https://gitter.im/opentracing/public

