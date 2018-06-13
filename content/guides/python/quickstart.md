---
title: "Python: Quick Start"
---

# Installation

First, start by spinning up an instance of a tracing backend. In this quick start, we'll use Jaeger:

```bash
$ docker run -d -p5775:5775/udp -p6831:6831/udp -p6832:6832/udp -p5778:5778 -p16686:16686 -p14268:14268 -p9411:9411 jaegertracing/all-in-one:0.8.0
```

One the container spins up, the Jaeger UI will be at [http://localhost:16686](http://localhost:16686).

# Setting up your First Tracer

* Link to Python walkthroughs / tutorials
* Setting up your tracer
* Start a Trace
* Create a Child Span
* Make An HTTP request
* View your trace
