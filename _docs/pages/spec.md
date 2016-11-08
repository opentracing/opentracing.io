# Concepts and Terminology


~~~
Causal relationships for Spans in a single trace


        [Span A]  ←←←(the root span)
            |
     +------+------+
     |             |
 [Span B]      [Span C] ←←←(Span C is a "ChildOf" Span A)
     |             |
 [Span D]      +---+-------+
               |           |
           [Span E]    [Span F] >>> [Span G] >>> [Span H]
                                       ↑
                                       ↑
                                       ↑
                         (Span G "FollowsFrom" Span F)

~~~

~~~
Temporal relationships for all of the above


––|–––––––|–––––––|–––––––|–––––––|–––––––|–––––––|–––––––|–> time

 [Span A···················································]
   [Span B··············································]
      [Span D··········································]
    [Span C········································]
         [Span E·······]        [Span F··] [Span G··] [Span H··]
~~~

## Traces

A **Trace** represents the potentially distributed, potentially concurrent data/execution path in a (potentially distributed, potentially concurrent) system. A Trace can be thought of as a directed acyclic graph (DAG) of Spans.

## Spans

A **Span** represents a logical unit of work in the system that has a start time and a duration. Spans may be nested and ordered to model causal relationships.

### Operation Names

Each Span has an **operation name**, a human-readable string which concisely represents the work done by the Span (e.g., an RPC method name, a function name, or the name of a subtask or stage within a larger computation). The operation name should be **the most general (i.e., least specific) string that identifies a (statistically) interesting class of Span instances**; more specific sub-classes should be described using [Tags](#tags).

For example, here are potential operation names for a Span that gets hypothetical account information:

| Operation Name | Guidance |
|:---------------|:--------|
| `get` | Too general |
| `get_account/792` | Too specific |
| `get_account` | Good, and `account_id=792` would make a nice [Tag](#tags) |

<span id="references"></span>

### Causal Span References

A Span may reference zero or more Spans that are causally related. OpenTracing presently defines two types of references: `ChildOf` and `FollowsFrom`. **Both reference types specifically model direct causal relationships between a child Span and a parent Span.** In the future, OpenTracing may also support reference types for spans with non-causal relationships (e.g., Spans that are batched together, Spans that are stuck in the same queue, etc).

**`ChildOf` references:** A Span may be the "ChildOf" a parent Span. In a "ChildOf" reference, the parent Span depends on the child Span in some capacity. All of the following would constitute ChildOf relationships:

- A Span representing the server side of an RPC may be the ChildOf a Span representing the client side of that RPC
- A Span representing a SQL insert may be the ChildOf a Span representing an ORM save method
- Many Spans doing concurrent (perhaps distributed) work may all individually be the ChildOf a single parent Span that merges the results for all children that return within a deadline

These could all be valid timing diagrams for children that are the "ChildOf" a parent.

~~~
    [-Parent Span---------]
         [-Child Span----]

    [-Parent Span--------------]
         [-Child Span A----]
          [-Child Span B----]
        [-Child Span C----]
         [-Child Span D---------------]
         [-Child Span E----]
~~~

**`FollowsFrom` references:** Some parent Spans do not depend in any way on the result of their child Spans. In these cases, we say merely that the child Span "FollowsFrom" the parent Span in a causal sense. There are many distinct "FollowsFrom" reference sub-categories, and in future versions of OpenTracing they may be distinguished more formally.

These can all be valid timing diagrams for children that "FollowFrom" a parent.

~~~
    [-Parent Span-]  [-Child Span-]


    [-Parent Span--]
     [-Child Span-]


    [-Parent Span-]
                [-Child Span-]
~~~

### Logs

Every Span has zero or more **Logs**, each of which being a timestamped event name, optionally accompanied by a structured data payload of arbitrary size. The event name should be the stable identifier for some notable moment in the lifetime of a Span. For instance, a Span representing a browser page load might add an event for each field in [Performance.timing](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming).

While it is not a formal requirement, specific event names should apply to many Span instances: tracing systems can use these event names (and timestamps) to analyze Spans in the aggregate.  For more information, see the [Data Conventions Guidelines](api/data-conventions).

<span id="tags"></span>

### Tags

Every Span may also have zero or more key:value **Tags**, which do not have timestamps and simply annotate the spans.

As is the case with Logs, if certain known tag key:values are used for common application scenarios, tracers can choose to pay special attention to them. For more information, see the [Data Conventions Guidelines](api/data-conventions).

## SpanContext

Every Span must provide access to a **SpanContext**. The SpanContext represents Span state that must propagate to child Spans and across process boundaries (e.g., a `<trace_id, span_id, sampled>` tuple) and also encapsulates any **Baggage** (see below). SpanContext is used when propagating traces across process boundaries and when creating edges in the trace graph (e.g., ChildOf relationships or other [references](#references)).

### Baggage

**Baggage** is a set of key:value pairs stored in a SpanContext and propagated _in-band_ to all child Spans and their SpanContexts: in this way, the "Baggage" travels with the trace, hence the name. Given a full-stack OpenTracing integration, Baggage enables powerful functionality by transparently propagating arbitrary application data: for example, an end-user id may be added as a Baggage item in a mobile app, propagate (via the distributed tracing machinery) into the depths of a storage system, and recovered at the bottom of the stack to identify a particularly expensive SQL query.

Baggage comes with powerful _costs_ as well; since the Baggage is propagated in-band, if it is too large or the items too numerous it may decrease system throughput or increase RPC latencies.

## Baggage vs. Span Tags

- Baggage is propagated in-band (i.e., alongside the actual application data) across process boundaries. Span Tags are not propagated since they are not inherited by child Spans.
- Span Tags are recorded out-of-band from the application data, presumably in the tracing system's storage. Implementations may choose to also record Baggage out-of-band, though that decision is not dictated by the OpenTracing specification.

## Inject and Extract

SpanContexts may be **Injected** into and **Extracted** from **Carrier** objects that are used for inter-process communication (e.g., HTTP headers). In this way, SpanContexts may propagate across process boundaries along with sufficient information to reference Spans (and thus continue traces) from remote processes.

# Platform-Independent API Semantics

OpenTracing supports a number of different platforms, and of course the per-platform APIs try to adhere to the idioms and conventions of their respective language and platform (i.e., they "do as the Romans do"). That said, each platform API must model a common set of semantics for the core tracing concepts described above. In this section we attempt to describe those concepts and semantics in a language- and platform-agnostic fashion.

## The `Span` Interface

The `Span` interface must have the following capabilities:

- **Get the `Span`'s [`SpanContext`](#SpanContext)** (even after the `Span` has finished, per Finish just below)
- **Finish** the (already-started) `Span`. With the exception of calls to retrieve the `SpanContext`, Finish must be the last call made to any span instance. **(py: `finish`, go: `Finish`)** Some implementations may record information about active `Span`s before they are Finished (e.g., for long-lived `Span` instances), or Finish may never be called due to host process failure or programming errors. Implementations should clearly document the `Span` durability guarantees they provide in such cases.
- **Set a key:value tag on the `Span`.** The key must be a `string`, and the value must be either a `string`, a `boolean`, or a numeric type. Behavior for other value types is undefined. If multiple values are set to the same key (i.e., in multiple calls), implementation behavior is also undefined. **(py: `set_tag`, go: `SetTag`)**
- **Add a new log event** to the `Span`, accepting an event name `string` and an optional structured payload argument. If specified, the payload argument may be of any type and arbitrary size, though implementations are not required to retain all payload arguments (or even all parts of all payload arguments). An optional timestamp can be used to specify a past timestamp. **(py: `log`, go: `Log`)**

## The `SpanContext` Interface

The `SpanContext` interface must have the following capabilities. The user acquires a reference to a `SpanContext` via an associated `Span` instance or via `Tracer`'s Extract capability.

- **Set a Baggage item**, represented as a simple string:string pair. Note that newly-set Baggage items are only guaranteed to propagate to *future* children of the associated `Span`. See the diagram below. **(py: `set_baggage_item`, go: `SetBaggageItem`)**
- **Get a Baggage item** by key. **(py: `get_baggage_item`, go: `BaggageItem`)**

~~~
        [Span A]
            |
     +------+------+
     |             |
 [Span B]      [Span C] ←←← (1) BAGGAGE ITEM "X" IS SET ON SPAN C,
     |             |            BUT AFTER SPAN E ALREADY STARTED.
 [Span D]      +---+-----+
               |         |
           [Span E]  [Span F] >>> [Span G] >>> [Span H]
                                                 ↑
                                                 ↑
                                                 ↑
             (2) BAGGAGE ITEM "X" IS AVAILABLE FOR
                 RETRIEVAL BY SPAN H (A CHILD OF
                 SPAN C), AS WELL AS SPANS F AND G.
~~~

- Though formally part of the `Tracer` interface, `SpanContext` is essential to [Inject and Extract](#inject-extract) below

## The `Tracer` Interface

The `Tracer` interface must have the following capabilities:

- **Start a new `Span`**. The caller can specify zero or more [`SpanContext` references](#references) (e.g., `FollowsFrom` or `ChildOf`), an explicit start timestamp (other than "now"), and an initial set of `Span` tags. **(py: `start_span`, go: `StartSpan`)**
- <span id="inject-extract"></span>**Inject a `SpanContext`** into a "carrier" object for cross-process propagation. The type of the carrier is either determined through reflection or an explicit [format identifier](/propagation#format-identifiers). See the [end-to-end propagation example](/propagation#propagation-example) to make this more concrete.
- **Extract a `SpanContext`** given a "carrier" object whose contents crossed a process boundary. Extract examines the carrier and tries to reconstruct the previously-Injected `SpanContext` instance. Unless there's an error, Extract returns a `SpanContext` which can be used in the host process like any other, most likely to start a new (child) Span. (Note that some OpenTracing implementations consider the `Span`s on either side of an RPC to have the same identity, and others consider the client to be the parent and the server to be the child) The type of the carrier is either determined through language reflection or an explicit [format](api/cross-process-tracing#format-identifiers). See the [end-to-end propagation example](api/cross-process-tracing#propagation-example) to make this more concrete.

### Global and No-op Tracers

A per-platform OpenTracing API library (e.g., [opentracing-go](https://github.com/opentracing/opentracing-go), [opentracing-java](https://github.com/opentracing/opentracing-java), etc; not OpenTracing `Tracer` *implementations*) must provide a no-op Tracer as part of their interface. The no-op Tracer implementation must not crash and should have no side-effects, including baggage propagation. The Tracer implementation must provide a no-op Span implementation as well; in this way, the instrumentation code that relies on Span instances returned by the Tracer does not need to change to accommodate the possibility of no-op implementations. The no-op Tracer's Inject method should always succeed, and Extract should always behave as if no `SpanContext` could be found in the carrier.

The per-platform OpenTracing API libraries *may* provide support for configuring (Go: `InitGlobalTracer()`, py: `opentracing.tracer = myTracer`) and retrieving (Go: `GlobalTracer()`, py: `opentracing.tracer`) a global/singleton Tracer instance. If a global Tracer is supported, the default must be the no-op Tracer.
