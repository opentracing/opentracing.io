---
layout: post
title: "weekly hangout: C#, HTTP encoding, key-value logging, reusing existing log instrumentation"
---

Attendees: @bg451, @pritianka, @bensigelman, @yurishkuro

Notes:

- Uber open-sourced their Java based tracer that uses OT. It's compatible with Zipkin out-of-band but does not use the B3 header (adding support would not be difficult).
- Regarding open issues gating the non-RC OpenTracing 1.0 Spec:
  - https://github.com/opentracing/opentracing-java/issues/31: trying to decide on a String for the format vs something cleaner from a type standpoint. We will enumerate the options on the issue and go from there.
  - https://github.com/opentracing/opentracing.github.io/issues/98:  We need to add HTTP support across the board. Present in some language APIs but not others right now.
  - https://github.com/opentracing/opentracing.github.io/issues/99: SpanContext mostly done.
  - https://github.com/opentracing/opentracing.github.io/issues/106: SpanContext immutability. Lots of discussion about this but there were too many tradeoffs to reach consensus. Will require more thought. Would be easier with a real workload since some of the motivating concerns are essentially about performance.
