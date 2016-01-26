---
layout: page
title: Semantic Specification
---
<div id="toc"></div>

## Concepts and Terminology


```
Parentage/causal relationships for spans from a single trace

        [Span A]  <--(the root span)
            |
     +------+------+
     |             |
 [Span B]      [Span C]
     |             |
 [Span D]      +---+-----+
               |         |
           [Span E]  [Span F]
                         |
                +--------+--------+
                |        |        |
            [Span G] [Span H] [Span I]

```

```
Temporal relationships for spans from a single trace

––|–––––––|–––––––|–––––––|–––––––|–––––––|–––––––|–––––––|–> time

 [Span A···················································]
   [Span B··············································]
      [Span D··········································]
    [Span C········································]
         [Span E···········]   [Span F········]
                                [Span G······]
                                [Span H··]
                                        [Span I·]
```

A **Trace** represents the potentially distributed, potentially concurrent data/execution path in a (potentially distributed, potentially concurrent) system. A Trace can be thought of as a tree of Spans. (See the ASCII diagrams above)

A **Span** represents a logical unit of work in the system that has a start time and a duration. Spans may be nested and ordered to model parent-child and casual relationships. Each span has an **operation name**, a presumably human-readable string which concisely names the work done by the span (e.g., an RPC method name, a function name, or the name of a subtask within a larger computation).

Every Span has zero or more **Logs**, each of which being a timestamped event name with an optional structured data payload of arbitrary size.

Every Span may also have zero or more key/value **Tags**, which do not have timestamps and simply annotate the spans.

Every Span is bound to a **Trace Context**. The Trace Context describes how the Span it's bound to fits in to the larger Trace. A Trace Context encapsulates the smallest amount of state needed to continue a Trace across a process boundary (or, more generally, a serialization boundary). Put another way, a Span cannot exist without a Trace Context, but a Trace Context can be (and is) serialized without a Span: Spans are built around their Trace Context and concern themselves with application-level instrumentation (logs, timing information, tags). Note that, in order to support *Trace Attributes* (see below) that propagate across a distributed Trace transparently, those attributes must be represented by/within the Trace Context.

**Trace Attributes** are key/value pairs stored in a Trace Context and propagated _in-band_ to all future child Spans. Given a full-stack OpenTracing integration, Trace Attributes enable powerful functionality by transparently propagating arbitrary application data: for example, an end-user id may be added as a Trace Attribute in a mobile app, propagate (via the distributed tracing machinery) into the depths of a storage system, and recovered at the bottom of the stack to identify a particularly expensive SQL query.

Trace Attributes come with powerful _costs_ as well; since the attributes are propagated in-band, if they are too large or too numerous they may reduce system throughput or contribute to RPC latency.

**Trace Attributes** vs. **Span Tags**

* Trace Attributes are propagated in-band (i.e., alongside the actual application data) across process boundaries. Span Tags are not propagated since they are not inherited from parent Span to child Span.
* Span Tags are recorded out-of-band from the application data, presumably in the tracing system's storage. Trace Attributes are not necessarily recorded here, though an implementation may elect to.

## Platform-Independent API Semantics

OpenTracing supports a number of different platforms, and of course the per-platform APIs try to blend in to their surroundings and do as the Romans do. That said, each platform API must model a common set of semantics for the core tracing concepts described above. In this document we attempt to describe those concepts and semantics in a language- and platform-agnostic fashion.

### Tracer

The `Tracer` interface must have the following capabilities:

- Start a `Span` that has no parent, commonly referred to as a *root* `Span` **(py: `start_trace`, go: `StartTrace`)**
- Start a `Span` as a descendant of a parent `TraceContext` **(py: `join_trace`, go: `JoinTrace`)**
- Start a `Span` explicitly built around a specific `TraceContext` **(py: `Span(trace_context)`, go: `StartSpanWithContext`)**


### Span

The `Span` interface must have the following capabilities:

- Create and start a new child `Span` with a given operation name. The child `Span`'s `TraceContext` must descend from the parent `Span`'s `TraceContext`, and any trace attributes must propagate through into the child's `TraceContext`. **(py: `start_child`, go: `StartChild`)**
- Finish the (already-started) `Span`.  Finish should be the last call made to any span instance, and to do otherwise leads to undefined behavior. **(py: `finish`, go: `Finish`)**
- Set a key:value tag on the `Span`. The key must be a `string`, and the value must be either a `string`, a `boolean`, or a numeric type. Behavior for other value types is undefined. If multiple values are set to the same key (i.e., in multiple calls), implementation behavior is also undefined. **(py: `set_tag`, go: `SetTag`)**
- Add a new log event to the `Span`, accepting an event name `string` and an optional structured payload argument. If specified, the payload argument may be of any type and arbitrary size, though implementations are not required to retain all payload arguments (or even all parts of all payload arguments). **(py: `log_event, log_event_with_payload`, go: `LogEvent, LogEventWithPayload`)**
- Access the `TraceContext` associated with the `Span`. **(py: `trace_context`, go: `TraceContext()`)**


### TraceContext

Every `TraceContext` must provide access to the "trace attributes". A **trace attribute** is a key:value pair associated with a TraceContext **that also propagates to future TraceContext children**, and that propagates across process boundaries in-band with the application data. (See the discussion of trace attributes in the "Concepts and Terminology" section above)

Also, trace attribute keys have a restricted format: implementations may wish to use them as HTTP header keys (or key suffixes), and of course HTTP headers are case insensitive. As such, trace attribute keys MUST match the regular expression `(?i:[a-z0-9][-a-z0-9]*)`, and – per the `?i:` – they are case-insensitive. That is, the trace attribute key must start with a letter or number, and the remaining characters must be letters, numbers, or hyphens.

In any case, the programmatic `TraceContext` interface is deceptively simple:

- Set a trace attribute, which is a simple string:string pair. Note that newly-set trace attributes are only guaranteed to propagate to *future* children of the `Span` built around the given `TraceContext`. See the diagram below. **(py: `set_trace_attribute`, go: `SetTraceAttribute`)**
- Get a trace attribute by key. **(py: `get_trace_attribute`, go: `TraceAttribute`)**

```
        [Span A]
            |
     +------+------+
     |             |
 [Span B]      [Span C]  <-- (1) ATTRIBUTE "X" IS SET ON SPAN C'S
     |             |             TRACECONTEXT, BUT AFTER SPAN E
 [Span D]      +---+-----+       ALREADY STARTED.
               |         |
           [Span E]  [Span F]   <-- (2) ATTRIBUTE "X" IS AVAILABLE
                         |              FOR RETRIEVAL BY SPAN F (A
                +--------+--------+     CHILD OF SPAN C), AS WELL
                |        |        |     AS SPANS G, H, AND I.
            [Span G] [Span H] [Span I]
```

### TraceContextSource, TraceContextEncoder, TraceContextDecoder

A complete `Tracer` implementation must also satisfy the requirements of the `TraceContextSource`, `TraceContextEncoder`, and `TraceContextDecoder` interfaces.

Implementations create `TraceContext` instances via a `TraceContextSource` interface; it must have the following capabilities:

- Create a new parent-less ("root") `TraceContext`. **(py: `new_root_trace_context`, go: `NewRootTraceContext`)**
- Create a new child `TraceContext` given a parent `TraceContext`. **(py: `new_child_trace_context`, go: `NewChildTraceContext`)**

Additionally, a `TraceContextSource` must be able to encode and decode `TraceContext`s. These interfaces are exposed so that reusable libraries and middleware can transport trace information opaquely without binding to the implementation details of any specific tracing system.

In its encoded form, a `TraceContext` is separated into a *pair* of values: one represents the "span identity" – for example, in Zipkin or Dapper, this would be the `trace_id` and `span_id`; and the other encoded value represents the trace attributes. This separation of encoded state enables optimizations in certain binary protocols. For instance, if a particular `TraceContext` has a fixed number of fixed-length "span identity" fields, then the span identity can be encoded into a fixed-length buffer (while of course the trace attributes cannot).

Note that there is no expectation that different tracing systems encode a `TraceContext` in compatible ways. Though OpenTracing is agnostic about the tracing implementation, for successful inter-process handoff it's essential that the processes on both sides use the same tracing implementation.

Depending on the language, support for `TraceContext` coding may involve extending or embedding `TraceContextEncoder` and `TraceContextDecoder` interfaces with the following capabilities:

Encoding and decoding may involve either **"binary"** or **"text"** formats. The "binary" format is an implementation-specific byte array (as opposed to a unicode/utf8 string); it is opaque at the OpenTracing level. The "text" format is a platform-idiomatic map from (unicode) `string` to `string`.

- Encoding a `TraceContext` as a pair of binary values **(py: `trace_context_to_binary`, go: `TraceContextToBinary`)**
- Encoding a `TraceContext` as a pair of text-encoded `string->string` maps, where the keys are suitable for HTTP headers (see the notes about "trace attribute" keys above) **(py: `trace_context_to_text`, go: `TraceContextToText`)**
- Decoding a `TraceContext` given a pair of binary values **(py: `trace_context_from_binary`, go: `TraceContextFromBinary`)**
- Decoding a `TraceContext` given a pair of textual `string->string` maps **(py: `trace_context_from_text`, go: `TraceContextFromText`)**
