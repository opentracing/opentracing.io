---
layout: post
title: weekly hangout notes
---

Rough notes from our weekly hangout:

- present: @adriancole @michaelsembwever @yurishkuro @adriancole
- general banter, etc, etc; notes not recorded for this part :)
- discussed @michaelsembwever’s work on https://issues.apache.org/jira/browse/CASSANDRA-10392
  - pretty neat: it basically creates an abstraction layer that makes distributed tracing within Cassandra pluggable
  - mck has bound that abstraction layer to zipkin successfully, thus allowing organizations to integrate distributed traces between callers of Cassandra and the underlying Cassandra internals
  - mck suggested that it would likely be possible to bind OT at that layer as well (and if not, that might indicate a design problem with OT)
- re opentracing/opentracing.github.io#70:
  - general consensus that Injector/Extractor and/or various registration mechanisms make sense for OT implementations, but nobody had any compelling use cases for keeping these concepts in the public OT API
  - as such, general consensus that the simplified API (with fewer moving parts/layers) is probably a better path forward… @bensigelman will add a note on the github issue and give folks 48h to object before moving forward with that simplification
  - see also @adriancole’s messages above ^^^ (which were from the meeting)
- status of the Java port more generally (https://github.com/opentracing/opentracing-java):
  - @michaelsembwever expects to polish up the existing PRs in the next day or so
  - @bensigelman brought up the fact that we’d like to support Android as well as server-side Java
    - using Java 8 is a problem on that front
    - unclear whether we will be able to have a single opentracing-java repo or if opentracing-android will have to get forked off (or maybe they would both depend on some core… hard to say at this point). TBD.
    - there may be some special semantics for mobile client tracing instrumentation, too, which warrant inclusion at the OT layer (since there’s a unique end-user associated with every Span, for instance)… though perhaps those details can be handled by the Tracer implementations on Android.
- mck is hoping to give a talk in Vancouver about tracing in general and would like to discuss OpenTracing at same
- meta: we talked about creating a wiki, or maybe just having a less-formal area of the Jekyll site, or maybe having a blog (perhaps for things like these weekly notes)
- meta: we may move to alternating times for alternating weeks… that way at least 50% of the meetings will be convenient for everyone (rather than the current arrangement where 100% of the meetings are a little rough for both the Oceanic people and the NYC/Boston people)
