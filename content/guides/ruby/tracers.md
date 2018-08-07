---
title: "Ruby: Tracers (Under Construction)"
---

### Tracer Interface

The Ruby `Tracer` interface creates `Spans` and understands how to `Inject` (serialize) and `Extract` (deserialize) their metadata across process boundaries. It has the following capabilities:

- Start a new `Span`
- `Inject` a `SpanContext` into a carrier
- `Extract` a `SpanContext` from a carrier

Each of these will be discussed in more detail below.

### Setting up a Tracer


### Starting a new Trace


### Accessing the Active Span


### Propagating a Trace with Inject/Extract
In order to trace across process boundaries in distributed systems, services need to be able to continue the trace injected by the client that sent each request. OpenTracing allows this to happen by providing inject and extract methods that encode a span's context into a carrier.
The `inject` method allows for the `SpanContext` to be passed on to a carrier. The `extract` method does the exact opposite. It extracts the `SpanContext` from the carrier.
