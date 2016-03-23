---
layout: post
title: weekly hangout notes
---

Very rough notes from our weekly hangout:

- attendees: @yurishkuro @tschottdorf @bg451 @dkuebric @bensigelman
- OT1.0RC is a thing: congrats/thanks all
- what to do about standardtracer?
  - the rough consensus was that it’s going to be hard to write a generalized set of impl helpers until we have more impls to generalize from.
  - fine to move the standard tracer out of the opentracing-go repo
  - fine to tightly-couple the standard tracer to some particular tracing backend
  - seems like appdash or perhaps (?) risingstack’s new Trace thing would be possible endpoints for same (note that the latter is a fork of the former, though)
- @dkuebric’s opentracing/opentracing.github.io#61
  - briefly, we will proceed with standardization of tags and concepts that commonly show up in individual traces
  - we will make less of an (perhaps no) effort trying to standardize things that affect trace aggregation and timeseries analysis since those areas are far more divergent across tracers
  - there is also the larger topic of in-process context propagation, but we’ll deal with that later
- meta: we’d like to move the meeting a few hours earlier since it’s mostly NYC/Boston people
