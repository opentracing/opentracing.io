---
layout: page
title: Semantic Specification
---

## Concepts and Terminology

A **Trace** represents the potentially distributed, potentially concurrent data/execution path in a (potentially distributed, potentially concurrent) system.

A **Span** represents a logical unit of work in the system that has a start time and an end time. Spans may be nested and ordered to model parent-child and casual relationships. A Trace can be thought of as a tree of Spans.

Every Span has zero or more **Logs**, each of which being a timestamped message with an optional structured data payload of arbitrary size.

Every Span may also have zero or more key/value **Tags**, which do not have timestamps and simply annotate the spans.

A **Trace Context** encapsulates the smallest amount of state needed to describe a Span's identity within a larger, potentially distributed trace, sufficient to propagate the context of a particular trace between processes.

**Trace Attributes** are key/value pairs stored in a Trace Context and propagated _in-band_ to all future child Spans. Given a full-stack OpenTracing integration, Trace Attributes enable powerful functionality by transparently propagating arbitrary application data: e.g., from a mobile app all the way into the depths of a storage system. Trace attributes come with powerful _costs_ as well; since the attributes are propagated in-band, if they are too large they can reduce system throughput or contribute to RPC latency. Use Trace Attributes with care.

**Trace Attributes** vs. **Span Tags**

* Trace Attributes are propagated in-band across process boundaries. Span Tags are not propagated.
* Span Tags are recorded off-band in the tracing system's storage. Trace Attributes are not recorded.

## Platform-Independent API Semantics

OpenTracing supports a number of different platforms, and of course the per-platform APIs try to blend in to their surroundings and do as the Romans do. That said, each platform API must model a common set of semantics for the core tracing concepts described above. In this document we attempt to describe those concepts and semantics in a language- and platform-agnostic fashion.

#### Tracer

The `Tracer` interface must have the following capabilities:

- Start a `Span` that has no parent **(py: `start_trace`, go: `StartTrace`)**
- Start a `Span` given a parent `TraceContext` **(py: `join_trace`, go: `JoinTrace`)**
- Start a `Span` associated with a specific `TraceContext` **(py: `start_span_with_context`, go: `StartSpanWithContext`)**


#### Span

The `Span` interface must have the following capabilities:

- Create and start a new child `Span` with a given operation name **(py: `start_child`, go: `StartChild`)**
- Finish the (already-started) `Span`.  Finish should be the last call made to any span instance, and to do otherwise leads to undefined behavior. **(py: `finish`, go: `Finish`)**
- Set a key:value tag on the `Span`. The key must be a `string`, and the value must be either a `string`, a `boolean`, or a numeric type. Behavior for other value types is undefined. If multiple values are set to the same key (i.e., in multiple calls), implementation behavior is also undefined. **(py: `set_tag`, go: `SetTag`)**
- Add a new info `Log` to the `Span`, accepting a message `string` and 0 or more payload arguments. The payload arguments may be of any type and arbitrary size, though implementations are not required to retain all payload arguments (or even all parts of all payload arguments). **(py: `info`, go: `Info`)**
- Add a new error `Log` to the `Span`; analagous to adding an info log aside from the severity. **(py: `error`, go: `Error`)**
- Access the `TraceContext` associated with the `Span`. **(py: `trace_context`, go: `TraceContext()`)**


#### TraceContext

Every `TraceContext` must provide access to "trace attributes". A **trace attribute** is a key:value pair associated with a TraceContext **that also propagates to future TraceContext children** per TraceContext.NewChild, and that propagates across process boundaries in-band with application data.

Trace attributes are powerful, especially given an OpenTracing integration that extends across many layers in a distributed stack. For example, arbitrary application data from a mobile app can travel, transparently, all the way into the depths of a storage system). These powerful capabilities come with some powerful costs: use this feature with care.

Also, trace attribute keys have a restricted format: implementations may wish to use them as HTTP header keys (or key suffixes), and of course HTTP headers are case insensitive.

As such, trace attribute keys MUST match the regular expression `(?i:[a-z0-9][-a-z0-9]*)`, and – per the `?i:` – they are case-insensitive.  That is, the trace attribute key must start with a letter or number, and the remaining characters must be letters, numbers, or hyphens. See CanonicalizeTraceAttributeKey(). If a trace attribute key does not meet these criteria, SetTraceAttribute() results in undefined behavior.

In any case, the programmatic `TraceContext` interface is deceptively simple:

- Set a trace attribute, which is a simple string:string pair. Note that newly-set trace attributes are only guaranteed to propagate to *future* children of the `TraceContext` and/or its associated `Span`. **(py: `set_trace_attribute`, go: `SetTraceAttribute`)**
- Get a trace attribute by key. **(py: `get_trace_attribute`, go: `TraceAttribute`)**


#### TraceContextSource, TraceContextEncoder, TraceContextDecoder

Implementations create `TraceContext` instances via a `TraceContextSource` interface; it must have the following capabilities:

- Create a new parent-less ("root") `TraceContext`. **(py: `new_root_trace_context`, go: `NewRootTraceContext`)**
- Create a new child `TraceContext` given a parent `TraceContext`. **(py: `new_child_trace_context`, go: `NewChildTraceContext`)**


Additionally, a `TraceContextSource` must be able to encode and decode `TraceContext`s. In its encoded form, a `TraceContext` is separated into a *pair* of values: one represents the "span identity" – for example, in Zipkin or Dapper, this would be the `trace_id` and `span_id`; and the other encoded value represents the trace attributes. This separation of encoded state enables optimizations in certain binary protocols.

Depending on the language, support for `TraceContext` coding may involve extending or embedding `TraceContextEncoder` and `TraceContextDecoder` interfaces with the following capabilities:

- Encoding a `TraceContext` as a pair of binary values **(py: `trace_context_to_binary`, go: `TraceContextToBinary`)**
- Encoding a `TraceContext` as a pair of text-encoded `string->string` maps, where the keys are suitable for HTTP heders (see the notes about "trace attribute" keys above) **(py: `trace_context_to_text`, go: `TraceContextToText`)**
- Decoding a `TraceContext` given a pair of binary values **(py: `trace_context_from_binary`, go: `TraceContextFromBinary`)**
- Decoding a `TraceContext` given a pair of textual `string->string` maps **(py: `trace_context_from_text`, go: `TraceContextFromText`)**
