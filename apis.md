---
layout: page
title: APIs
---
The following OpenTracing APIs are currently available in the RFC stage:

* Golang - https://github.com/opentracing/api-golang
* Python - https://github.com/opentracing/api-python

Please refer to the README files in the respective projects for examples of usage.

### Implementation Notes

OpenTracing APIs intend to express a similar experience to the user, while still being idiomatic to the language or framework. The following concepts apply to all variants.

A **Span** is shared mutable state. It accumulates tags and logs, and can also create children. Finishing a span means capturing its state as a SpanRecord.

A **SpanRecord** is an immutable representation of a completed span. It can be reported directly to an OpenTracing system, or encoded into a representation of an alternate system, such as HTrace or Zipkin.
