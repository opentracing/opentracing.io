---
layout: page
title: Semantic Specification and Terminology
---

A **Trace** represents the potentially distributed, potentially concurrent data/execution path in a (potentially distributed, potentially concurrent) system.

A **Span** represents a logical unit of work in the system that has a start time and an end time. Spans can be nested and ordered to model parent-child and casual relationships. A Trace can be thought of as a tree of Spans. Every Span has zero or more **Logs**, each of which being a timestamped message with an optional structured data payload of arbitrary size. Every Span may also have zero or more key/value **Tags**, which do not have timestamps and simply annotate the spans.

A **Trace Context** encapsulates the smallest amount of state needed to describe a Span's identity within a larger, potentially distributed trace, sufficient to propagate the context of a particular trace between processes.

**Trace Attributes** are key/value pairs stored in a Trace Context and propagated _in-band_ to all future children Spans. Given a full-stack OpenTracing integration, Trace Attributes enable powerful functionality by transparently propagating arbitrary application data; e.g., from a mobile app all the way into the depths of a storage system. It comes with powerful _costs_ as well, since the attributes are propagated in-band, alongside the application data; use Trace Attributes with care.

**Trace Attributes** vs. **Span Tags**

* Trace Attributes are propagated in-band across process boundaries. Span Tags are not propagated.
* Span Tags are recorded off-band in the tracing system's storage. Trace Attributes are not recorded.

