---
layout: page
title: Semantic Specification
---
<div id="toc"></div>

# Concepts and Terminology


~~~
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

~~~

~~~
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
~~~

A **Trace** represents the potentially distributed, potentially concurrent data/execution path in a (potentially distributed, potentially concurrent) system. A Trace can be thought of as a tree of Spans. (See the ASCII diagrams above)

A **Span** represents a logical unit of work in the system that has a start time and a duration. Spans may be nested and ordered to model parent-child and casual relationships. Each span has an **operation name**, a presumably human-readable string which concisely names the work done by the span (e.g., an RPC method name, a function name, or the name of a subtask within a larger computation).

Every Span has zero or more **Logs**, each of which being a timestamped event name, optionally accompanied by a structured data payload of arbitrary size. The event name should be the stable identifier for some notable moment in the lifetime of a Span. For instance, a Span representing a browser page load might add an event for each of the Performance.timing moments.  While it is not a formal requirement, specific event names should apply to many Span instances: tracing systems can use these event names (and timestamps) to analyze Spans in the aggregate.

Every Span may also have zero or more key/value **Tags**, which do not have timestamps and simply annotate the spans.

Spans may be **Injected** into and **Extracted** from objects that are used for inter-process communication (e.g., HTTP headers). In this way, Spans may propagate across process boundaries along with sufficient information to join up with the Trace in some remote process.

**Baggage** is a set of key/value pairs stored in a Span and propagated _in-band_ to all future children Spans: in this way, the "Baggage" travels with the trace, hence the name. Given a full-stack OpenTracing integration, Baggage enables powerful functionality by transparently propagating arbitrary application data: for example, an end-user id may be added as a Baggage item in a mobile app, propagate (via the distributed tracing machinery) into the depths of a storage system, and recovered at the bottom of the stack to identify a particularly expensive SQL query.

Baggage comes with powerful _costs_ as well; since the Baggage is propagated in-band, if it is too large or the items too numerous it may decrease system throughput or increase RPC latencies.

**Baggage** vs. **Span Tags**

- Baggage is propagated in-band (i.e., alongside the actual application data) across process boundaries. Span Tags are not propagated since they are not inherited from parent Span to child Span.
- Span Tags are recorded out-of-band from the application data, presumably in the tracing system's storage. Implementations may choose to also record Baggage out-of-band, though that decision is not dictated by the OpenTracing specification.

Also, Baggage keys have a restricted format: implementations may wish to use them as HTTP header keys (or key suffixes), and of course HTTP headers are case insensitive. As such, Baggage keys MUST match the regular expression `(?i:[a-z0-9][-a-z0-9]*)`, and – per the `?i:` – they are case-insensitive. That is, the Baggage key must start with a letter or number, and the remaining characters must be letters, numbers, or hyphens.


# Platform-Independent API Semantics

OpenTracing supports a number of different platforms, and of course the per-platform APIs try to adhere to the idioms and conventions of their respective language and platform (i.e., they "do as the Romans do"). That said, each platform API must model a common set of semantics for the core tracing concepts described above. In this document we attempt to describe those concepts and semantics in a language- and platform-agnostic fashion.

## Span

The `Span` interface must have the following capabilities:

- Finish the (already-started) `Span`.  Finish should be the last call made to any span instance, and to do otherwise leads to undefined behavior. **(py: `finish`, go: `Finish`)**
- Set a key:value tag on the `Span`. The key must be a `string`, and the value must be either a `string`, a `boolean`, or a numeric type. Behavior for other value types is undefined. If multiple values are set to the same key (i.e., in multiple calls), implementation behavior is also undefined. **(py: `set_tag`, go: `SetTag`)**
- Add a new log event to the `Span`, accepting an event name `string` and an optional structured payload argument. If specified, the payload argument may be of any type and arbitrary size, though implementations are not required to retain all payload arguments (or even all parts of all payload arguments). An optional timestamp can be used to specify a past timestamp. **(py: `log`, go: `Log`)**
- Set a Baggage item, represented as a simple string:string pair. Note that newly-set Baggage items are only guaranteed to propagate to *future* children of the given `Span`. See the diagram below. **(py: `set_baggage_item`, go: `SetBaggageItem`)**
- Get a Baggage item by key. **(py: `get_baggage_item`, go: `BaggageItem`)**

~~~
        [Span A]
            |
     +------+------+
     |             |
 [Span B]      [Span C]  <-- (1) BAGGAGE ITEM "X" IS SET ON SPAN C,
     |             |             BUT AFTER SPAN E ALREADY STARTED.
 [Span D]      +---+-----+
               |         |
           [Span E]  [Span F]   <-- (2) BAGGAGE ITEM "X" IS AVAILABLE
                         |              FOR RETRIEVAL BY SPAN F (A
                +--------+--------+     CHILD OF SPAN C), AS WELL
                |        |        |     AS SPANS G, H, AND I.
            [Span G] [Span H] [Span I]
~~~


## Tracer

The `Tracer` interface must have the following capabilities:

- Start a new `Span`. There must be a way for the caller to specify a parent `Span`, an explicit start timestamp (other than "now"), and an initial set of `Span` tags. **(py: `start_span`, go: `StartSpanWithOptions`)**
- Return an `Injector` instance given a [format identifier](#format-identifiers), or nil/null if the format is not supported by the implementation (see [Injector and Extractor](#injector-and-extractor))
- Return an `Extractor` instance given a [format identifier](#format-identifiers), or nil/null if the format is not supported by the implementation (see [Injector and Extractor](#injector-and-extractor))


<div id="format-identifiers"></div>

A note about **"format identifiers"** per the `Injector` and `Extractor` lookup methods above: the nature of the "format identifier" may vary from platform to platform, but in all cases they should be drawn from a global namespace. New formats must not *require* changes to the core OpenTracing platform APIs, though those core platform APIs must define a few basic/general formats (like string maps and binary blobs). For example, if the maintainer of EsotericRPCFramework wanted to define an EsotericRPCFramework injection and extraction format, she or he must be able to do so without sending a PR to OpenTracing maintainers (though of course OpenTracing implementations are not required to suppor the EsotericRPCFramework format). There is [an end-to-end injector and extractor example below](#propagation-example) to make this more concrete.

## Injector and Extractor

The `Injector` and `Extractor` interfaces allow Traces to propagate across process boundaries. They are not entirely symmetrical interfaces since `Span` injection is a fundamentally lossy process (most of the `Span`'s state is meant to be recorded out-of-band from the application's own communication path, whereas Inject-ed state is meant to be sent in-band with the application data).

- An `Injector` has one method: `InjectSpan`. InjectSpan takes two arguments: a `Span` instance and a "carrier" object in which to inject that `Span` for cross-process propagation. The type of the carrier depends on the particular type of the `Injector`, and the type of the `Injector` in turn depends on the [format identifier](#format-identifiers) passed to `Tracer.Extractor(...)`.
- An `Extractor` has one method: `JoinTrace`. JoinTrace takes two arguments: the operation name for the `Span` it's about to create and a "carrier" object from which to extract identifying information needed by the new `Span` instance. Unless there's an error, it returns a freshly-started `Span` which can be used in the host process like any other. (Note that some OpenTracing implementations consider the `Span`s on either side of an RPC to have the same identity, and others consider the caller to be the parent and the receiver to be the child) The type of the carrier depends on the type of the `Extractor`, and the type of the `Extractor` in turn depends on the [format identifier](#format-identifiers) passed to `Tracer.Extractor(...)`.

#### Required Injector/Extractor formats

At a minimum, all platforms require OpenTracing implementations to support two formats: the "split text" format and the "split binary" format. The "split" refers to two common components of propagated spans:

1. The core identifying information for the `Span`, referred to as the "tracer state" (for example, in Dapper this would include a `trace_id`, a `span_id`, and a bitmask representing the sampling status for the given trace)
1. Any Baggage (per `Span`'s ability to set Baggage items that propagate across process boundaries)

The "text" and "binary" designations refer to two flavors of encoding:

- The *text* format is a platform-idiomatic map from (unicode) `string` to `string`
- The *binary* format is an opaque byte array (and presumably more compact and efficient)

Note that there is no expectation that different tracing systems Inject and Extract `Spans` in compatible ways. Though OpenTracing is agnostic about the tracing implementation, for successful inter-process handoff it's essential that the processes on both sides of a propagation use the same tracing implementation.

<div id="propagation-example"></div>

#### An end-to-end Injector and Extractor propagation example

To make the above more concrete, consider the following sequence:

1. A client process has a `Span` instance and is about to make an RPC over a home-grown HTTP protocol
1. That client process calls some `Tracer.Injector(...)` method, passing a format identifier for a string map
1. With an `Injector` instance in hand, the client calls `injector.InjectSpan(...)`, passing the active `Span` instance and a string map carrier in as parameters
1. The newly-populated (opaque) string map is encoded into the homegrown HTTP protocol (e.g., as headers) by the application code
1. Now in the server process, the application code grabs the opaque string map from the homegrown HTTP protocol
1. The server process calls some `Tracer.Extractor(...)` method, again passing a format identifier for a string map
1. With an `Extractor` instance in hand, the server calls `extractor.JoinTrace(...)`, passing in the desired operation name and the opaque string map from above (as the carrier)
1. In the absence of data corruption or other errors, the server now has a `Span` instance that belongs to the same trace as the one in the client

More concrete examples can be found among the [OpenTracing use cases](/use-cases).

