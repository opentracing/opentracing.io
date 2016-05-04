---
layout: page
title: Everything You Wanted to Know About Inject and Join but were Afraid to Ask
---

Programmers adding tracing support across process boundaries must understand the `Tracer.Inject(...)` and `Tracer.Join(...)` capabilities of [the OpenTracing specification](/spec). They are conceptually powerful, allowing the programmer to write *correct* and *general* cross-process propagation code **without being bound to a particular OpenTracing implementation**; that said, with great power comes great opportunity for confusion. :)

This document provides a concise summary of the design and proper use of `Inject` and `Join`, regardless of the particular OpenTracing language or OpenTracing implementation.

## "The Big Picture" for explicit trace propagation

The hardest thing about distributed tracing is the *distributed* part. Any tracing system needs a way of understanding the causal relationship between activities in many distinct processes, whether they be connected via formal RPC frameworks, pub-sub systems, generic message queues, ad hoc HTTP calls, best-effort UDP packets, or something else entirely.

Some distributed tracing systems (e.g., [Project5](http://dl.acm.org/citation.cfm?id=945454) from 2003, or [WAP5](http://www2006.org/programme/item.php?id=2033) from 2006 or [The Mystery Machine](https://www.usenix.org/node/186168) from 2014) *infer* causal relationships across process boundaries. Of course **there is a tradeoff between the apparent convenience of these black-box inference-based approaches and the ultimate freshness and quality of the assembled traces.** Per the concern about quality, OpenTracing is an *explicit* distributed tracing instrumentation standard, and as such it is much better-aligned with approaches like [X-Trace](https://www.usenix.org/conference/nsdi-07/x-trace-pervasive-network-tracing-framework) from 2007, [Dapper](http://research.google.com/pubs/pub36356.html) from 2010, or numerous open-source tracing systems like [Zipkin](https://github.com/openzipkin) or [Appdash](https://github.com/sourcegraph/appdash) (among others).

Let's briefly restate the "Why OpenTracing?" section of the [OpenTracing landing page](/):

> By offering consistent, expressive, vendor-neutral APIs for popular platforms, OpenTracing makes it easy for developers to add (or switch) tracing implementations with an O(1) configuration change. OpenTracing also offers a lingua franca for OSS instrumentation and platform-specific tracing helper libraries.

**Together, `Inject` and `Join` allow for inter-process trace propagation without tightly coupling the programmer to a particular OpenTracing implementation.** 

## Requirements for the OpenTracing propagation scheme

For `Inject` and `Join` to be useful, all of the following must be true:

- Per the above, the [OpenTracing user](/use-cases/#stepping-back-who-is-opentracing-for) handling cross-process trace propagation must not need to write OpenTracing-implementation-specific code
- OpenTracing implementations must not need special handlers for every known inter-process communication mechanism: that's far too much work, and it's not even well-defined
- That said, the propagation mechanism should be extensible for optimizations

## The basic approach: Inject, Join, and Carriers

Any Span in a trace may be **Injected** into what OpenTracing refers to as a Carrier. A **Carrier** is an interface or data structure useful for inter-process communication (IPC); that is, the Carrier is something that "carries" the tracing state from one process to another. The OpenTracing specification includes two [required Carrier formats](#required-carriers), though [custom Carrier formats](#custom-carriers) are possible as well.

Similarly, given a Carrier, an injected trace may be **Joined**, yielding a new Span. We use the term "Join" rather than "Extract" (or similar) because Inject/Join is not a symmetric process: an OpenTracing implementation is only expected to inject the minimal amount of information needed to constunct a (descendant) Span in the peer and join it to the overarching trace. The injected state is *not* necessarily sufficient to reconstruct the entire injected Span instance, symmetrically.

#### Inject pseudocode example

{% highlight python %}
span = ...
outboundRequest = ...

# We'll use the (builtin) TEXT_MAP carrier format. We start by
# using an empty map as the carrier prior to the call to
# `tracer.inject`.
carrier = {}
tracer.inject(span, opentracing.Format.TEXT_MAP, carrier)

# `carrier` now contains (opaque) key:value pairs which we pass
# along over whatever wire protocol we already use.
for key, value in carrier:
    outboundRequest.headers[key] = escape(value)
{% endhighlight %}

#### Join pseudocode example

{% highlight python %}
inboundRequest = ...

# We'll again use the (builtin) TEXT_MAP carrier format. Per the
# TEXT_MAP documentation, we can use a map that has extraneous data
# in it and let the OpenTracing implementation look for the subset
# of key:value pairs it needs.
#
# As such, we directly use the key:value `inboundRequest.headers`
# map as the carrier.
carrier = inboundRequest.headers
# The operation name we want for the server-side span:
operationName = ...
serverSpan = tracer.join(
    operationName, opentracing.Format.TEXT_MAP, carrier)

# (If `carrier` held trace data, `span` will now be ready to use.)
{% endhighlight %}

#### Carriers have formats

All Carriers have a format. In some OpenTracing languages, the format must be specified explicitly as a constant or string; in others, the format is inferred from the Carrier's static type information.

#### Not Symmetric

When a Span is injected into a Carrier, the OpenTracing implementation only encodes the minimum amount of information needed to join with the trace in a remote process. As such, **`Inject` and `Join` are not glorified serialization and deserialization methods:** the Span returned by `Join` is not the Span passed to `Inject`.

<div id="required-carriers"></div>

## Required Inject/Join Carrier formats

At a minimum, all platforms require OpenTracing implementations to support two Carrier formats: the "text map" format and the "binary" format.

- The *text map* Carrier format is a platform-idiomatic map from (unicode) `string` to `string`
- The *binary* Carrier format is an opaque byte array (and presumably more compact and efficient)

What the OpenTracing implementations choose to store in these Carriers is not formally defined by the OpenTracing specification, but the presumption is that they find a way to encode "tracer state" about the propagated `Span` (e.g., in Dapper this would include a `trace_id`, a `span_id`, and a bitmask representing the sampling status for the given trace) as well as any key:value Baggage items.

### Interoperability of OpenTracing implementations *across process boundaries*

There is no expectation that different OpenTracing implementations `Inject` and `Join` Spans in compatible ways. Though OpenTracing is agnostic about the tracing implementation *across an entire distributed system*, for successful inter-process handoff it's essential that the processes on both sides of a propagation use the same tracing implementation.

<div id="custom-carriers"></div>

## Custom Inject/Join Carrier formats

Any propagation subsystem (an RPC library, a message queue, etc) may choose to introduce their own custom Inject/Join Carrier format; by preferring their custom format **but falling back to a required OpenTracing format as needed** they allow OpenTracing implemantations to optimize for their custom format without *needing* OpenTracing implementations to support their format.


Some pseudocode will make this less abstract. Imagine that we're the author of the (sadly fictitious) **ArrrPC pirate RPC subsystem**, and we want to add OpenTracing support to our outbound RPC requests. Minus some error handling, our pseudocode might look like this:

{% highlight python %}
span = ...
outboundRequest = ...

# First we try our custom Carrier, the outboundRequest itself.
# If the underlying OpenTracing implementation cares to support
# it, this call is presumably more efficient in this process
# and over the wire. But, since this is a non-required format,
# we must also account for the possibility that the OpenTracing
# implementation does not support arrrpc.ARRRPC_OT_CARRIER.
try:
    tracer.inject(span, arrrpc.ARRRPC_OT_CARRIER, outboundRequest)

except opentracing.UnsupportedFormatException:
    # If unsupported, fall back on a required OpenTracing format.
    carrier = {}
    tracer.inject(span, opentracing.Format.TEXT_MAP, carrier)
    # `carrier` now contains (opaque) key:value pairs which we
    # pass along over whatever wire protocol we already use.
    for key, value in carrier:
	outboundRequest.headers[key] = escape(value)
{% endhighlight %}

<div id="format-identifiers"></div>

### More about custom Carrier formats

The precise representation of the "Carrier formats" may vary from platform to platform, but in all cases they should be drawn from a global namespace. New formats must not *require* changes to the core OpenTracing platform APIs, though those core platform APIs must define a few basic/general formats (like string maps and binary blobs). For example, if the maintainer of ArrrPC RPC framework wanted to define an "ArrrPC" inject/join format, she or he must be able to do so without sending a PR to OpenTracing maintainers (though of course OpenTracing implementations are not required to support the "ArrrPC" format). There is [an end-to-end injector and extractor example below](#propagation-example) to make this more concrete.


<div id="propagation-example"></div>

## An end-to-end Inject and Join propagation example

To make the above more concrete, consider the following sequence:

1. A *client* process has a `Span` instance and is about to make an RPC over a home-grown HTTP protocol
1. That client process calls `Tracer.Inject(...)`, passing the active `Span` instance, a format identifier for a text map, and a text map Carrier as parameters
1. `Inject` has populated the text map in the Carrier; the client application encodes that map within its homegrown HTTP protocol (e.g., as headers)
1. *The HTTP request happens and the data crosses process boundaries...*
1. Now in the server process, the application code decodes the text map from the homegrown HTTP protocol and uses it to initialize a text map Carrier
1. The server process calls `Tracer.Join(...)`, passing in the desired operation name, a format identifier for a text map, and the Carrier from above
1. In the absence of data corruption or other errors, the *server* now has a `Span` instance that belongs to the same trace as the one in the client

Other examples can be found in the [OpenTracing use cases](/use-cases) doc.
