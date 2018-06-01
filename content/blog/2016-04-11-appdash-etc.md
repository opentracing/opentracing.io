---
title: "overdue updates: appdash, brave, C++, DAG tracing"
---

We've been lazy about meeting notes lately (shame on @bensigelman) and, as such, we have overdue updates about a variety of things:

- @bg451 built an OpenTracing `Tracer` for [Appdash](https://github.com/sourcegraph/appdash). Here's [the code](https://github.com/sourcegraph/appdash/tree/master/opentracing). Thanks to @slimsag for the review.
- @michaelsembwever sent out [an OpenTracing-Brave bridge PR](https://github.com/opentracing/opentracing-java/pull/25) which @kristofa ([Brave](https://github.com/openzipkin/brave) lead) is looking at
- @lookfwd sent out an [C++ OpenTracing API PR](https://github.com/lookfwd/opentracing-cpp/pull/1) which has spawned a variety of other more fundamental discussions...
  - Of particular interest is the [issue about unfinished spans and generalized causality DAG annotations](https://github.com/opentracing/opentracing.github.io/issues/85)

