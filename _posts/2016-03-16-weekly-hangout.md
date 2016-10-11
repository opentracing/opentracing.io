---
title: "weekly hangout: inject/join, ot-java discussion, appdash"
---

- talking about inject/join/carrier stuff (sadly without Adrian who fell victim to US DST changes)
  - TL;DR: specific examples implemented for this stuff would be enormously useful ( hence opentracing/opentracing.github.io#79)
  - some confusion about the DI aspects of Adrian’s concerns above (in Gitter)
- @michaelsembwever is going to work on the PR 11 in ot-java a bit
  - re log-builder in Java: mck says “first and foremost, just an RFC”; also, it doesn’t need to feel exactly like a “normal” logging API… can be more like an event-based API. The builder approach emphasizes that.
  - another idea would be to add a notion / awareness of events as plumbing and various logging-style methods "on top”
- could be an argument to add a clean/porcelain API later since it’s easier to get wrong
- what would prevent someone from binding OT to Cassandra ~now… mck says “very little” (and sent a link above in Gitter).
- hoping to get some Docker code into their master branch next quarter
- Brandon’s Appdash change is almost in
- going to actually do this: opentracing/opentracing.github.io#78
- need to reach out to @kristofa the Brave maintainer to understand OT blockers
