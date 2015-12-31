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

### Terminology

A **Trace** represents the potentially distributed, potentially concurrent data/execution path in a (potentially distributed, potentially concurrent) system.

A **Span** represents a logical unit of work in the system that has a start time and an end time. Spans can be nested and ordered to model parent-child and casual relationships. A Trace can be thought of as a tree of Spans. Every Span has zero or more **Logs**, each of which being a timestamped message with an optional payload. Every Span may also have zero or more key/value **Tags**, which do not have timestamps and simply annotate the spans.

A **Trace Context** encapsulates the smallest amount of state needed to describe a Span's identity within a larger, potentially distributed trace, sufficient to propagate the context of a particular trace between processes.

**Trace Attributes** are key/value pairs stored in a Trace Context and propagated _in-band_ to all future children Spans. Given a full-stack OpenTracing integration, Trace Attributes enable powerful functionality by transparently propagating arbitrary application data; e.g., from a mobile app all the way into the depths of a storage system. It comes with powerful _costs_ as well, since the attributes are propagated in-band, alongside the application data; use Trace Attributes with care.

**Trace Attributes** vs. **Span Tags**

* Trace Attributes are propagated in-band across process boundaries. Span Tags are not propagated.
* Span Tags are recorded off-band in the tracing system's storage. Trace Attributes are not recorded.

### Language Support

The OpenTracing project aims to provide APIs for all popular platforms. The APIs have standard semantic capabilities and must not be tightly coupled to any particular downstream tracing or monitoring system (Zipkin, etc). Our initial target languages are Go, Python, Java, and Javascript, with more to follow.

## Authors and Contributors 
(in alphabetical order)

* Adrian Cole (@adriancole)
* Ben Sigelman (@bensigelman)
* Stephen Gutekanst (@slimsag)
* Yuri Shkuro (@yurishkuro)

## Support or Contact
Open an issue against one of the repositories, or start a discussion in the [Distributed Tracing](https://groups.google.com/forum/#!forum/distributed-tracing) Google group.

