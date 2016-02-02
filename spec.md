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

Spans may be **propagated**; that is, they may cross process boundaries along with sufficient information to continue the Trace on the far side of the propagation.

**Trace Attributes** are key/value pairs stored in a Span and propagated _in-band_ to all future child Spans. Given a full-stack OpenTracing integration, Trace Attributes enable powerful functionality by transparently propagating arbitrary application data: for example, an end-user id may be added as a Trace Attribute in a mobile app, propagate (via the distributed tracing machinery) into the depths of a storage system, and recovered at the bottom of the stack to identify a particularly expensive SQL query.

Trace Attributes come with powerful _costs_ as well; since the attributes are propagated in-band, if they are too large or too numerous they may reduce system throughput or contribute to RPC latency.

**Trace Attributes** vs. **Span Tags**

* Trace Attributes are propagated in-band (i.e., alongside the actual application data) across process boundaries. Span Tags are not propagated since they are not inherited from parent Span to child Span.
* Span Tags are recorded out-of-band from the application data, presumably in the tracing system's storage. Trace Attributes are not necessarily recorded here, though an implementation may elect to.

Also, trace attribute keys have a restricted format: implementations may wish to use them as HTTP header keys (or key suffixes), and of course HTTP headers are case insensitive. As such, trace attribute keys MUST match the regular expression `(?i:[a-z0-9][-a-z0-9]*)`, and – per the `?i:` – they are case-insensitive. That is, the trace attribute key must start with a letter or number, and the remaining characters must be letters, numbers, or hyphens.


## Platform-Independent API Semantics

OpenTracing supports a number of different platforms, and of course the per-platform APIs try to blend in to their surroundings and do as the Romans do. That said, each platform API must model a common set of semantics for the core tracing concepts described above. In this document we attempt to describe those concepts and semantics in a language- and platform-agnostic fashion.

### Span

The `Span` interface must have the following capabilities:

- Create and start a new child `Span` with a given operation name. Any trace attributes must be passed through into the child. **(py: `start_child`, go: `StartChild`)**
- Finish the (already-started) `Span`.  Finish should be the last call made to any span instance, and to do otherwise leads to undefined behavior. **(py: `finish`, go: `Finish`)**
- Set a key:value tag on the `Span`. The key must be a `string`, and the value must be either a `string`, a `boolean`, or a numeric type. Behavior for other value types is undefined. If multiple values are set to the same key (i.e., in multiple calls), implementation behavior is also undefined. **(py: `set_tag`, go: `SetTag`)**
- Add a new log event to the `Span`, accepting an event name `string` and an optional structured payload argument. If specified, the payload argument may be of any type and arbitrary size, though implementations are not required to retain all payload arguments (or even all parts of all payload arguments). **(py: `log_event, log_event_with_payload`, go: `LogEvent, LogEventWithPayload`)**
- Set a trace attribute, which is a simple string:string pair. Note that newly-set trace attributes are only guaranteed to propagate to *future* children of the given `Span`. See the diagram below. **(py: `set_trace_attribute`, go: `SetTraceAttribute`)**
- Get a trace attribute by key. **(py: `get_trace_attribute`, go: `TraceAttribute`)**

```
        [Span A]
            |
     +------+------+
     |             |
 [Span B]      [Span C]  <-- (1) ATTRIBUTE "X" IS SET ON SPAN C,
     |             |             BUT AFTER SPAN E ALREADY STARTED.
 [Span D]      +---+-----+
               |         |
           [Span E]  [Span F]   <-- (2) ATTRIBUTE "X" IS AVAILABLE
                         |              FOR RETRIEVAL BY SPAN F (A
                +--------+--------+     CHILD OF SPAN C), AS WELL
                |        |        |     AS SPANS G, H, AND I.
            [Span G] [Span H] [Span I]
```


### Tracer

The `Tracer` interface must have the following capabilities:

- Start a `Span` that has no parent, commonly referred to as a *root* `Span` **(py: `start_trace`, go: `StartTrace`)**
- Provide access to a SpanInjector and SpanExtractor that's appropriate for a specified IPC system, or a helper implementation that can be delegated to. **(py: `get_span_injector, get_span_extractor`, go: `GetSpanInjector, GetSpanExtractor`)**

### SpanInjector

The `SpanInjector` interface must have the following capabilities:
 - inject the span into the middleware object **(py: `inject`, go: `inject`)**

### SpanExtractor

The `SpanExtractor` interface must have the following capabilities:
 - extract the span from the middleware object **(py: `extract`, go: `extract`)**