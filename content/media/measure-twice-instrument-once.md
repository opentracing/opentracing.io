---
title: "OpenTracing Isn't Just Tracing: Measure Twice, Instrument Once"
videoUrl: https://www.youtube.com/embed/NyySNe6Rr_g
thumbnail: https://img.youtube.com/vi/NyySNe6Rr_g/maxresdefault.jpg
layout: video
featured: false
date: 2017-03-29
---

Those building microservices at scale understand the role and importance of distributed tracing: it’s the most direct way to understand how and why a system is misbehaving. However, often this information has been hard to procure, given the challenges of explicit instrumentation, and once obtained, it is siloed from other relevant data such as logging and other monitoring.

The OpenTracing project provides a standard, portable API for distributed tracing instrumentation and changes that. In this talk, Priyanka and Ted will begin by describing OpenTracing and explaining why anyone who monitors microservices should care about it. Having laid that groundwork, the talk will step back to examine the historical role of operational logging and metrics in distributed system monitoring, then illustrate how the OpenTracing API maps to these tried-and-true abstractions. There will also be a demo involving donuts, distributed traces, and prometheus monitoring (all via OpenTracing).
