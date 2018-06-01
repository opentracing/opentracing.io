---
title: "weekly hangout: metadata standard, sync.Pool, Uber's OT-Zipkin bridge"
---

Rough notes:

- 6 minutes of futzing with Hangouts technology :)
- Re @dkuebric's PR:
  - payload specification for error events
  - payloads would need to be key:value based
  - or should we just drop it for now?
  - resolution is to leave this as "future work" for now
  - need a link from semantic spec page
- Uber Go issue with sync.Pool and invalid Spans
  - async tasks are still troublesome... how do we want to represent them?
  - @dkuebric: how to represent big traces with lots of async behavior?
    - 10m limit is fine for web-based systems
    - how to "chop up" long traces with periods of intense activity / subtraces?
    - i.e., metatraces ^^^
    - how about using Join with JoinOptions to express the type of parent pointer?
    - relative agreement that this is a tricky thing to get "right" and may wait until OT has more of an integrated base
    - next-ish step after this PR will be codegen for the standard tags
- @bensigelman's Twitter talk: core Finagle team interested in talking more about OpenTracing/etc
- re Uber OSS'ing OT-to-Zipkin bindings:
  - @yurishkuro wants that to be done this quarter... repos are created, sorting out some dependencies
  - Getting rid of TChannel dependency and doing localhost UDP
  - Definitely coming once the above is done... probably next ~3 weeks
  - Not using the B3 header, though that could be addressed with a custom carrier if need be

