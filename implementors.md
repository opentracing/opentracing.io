---
layout: page
title: Implementing the OpenTracing APIs
---

### Why OpenTracing?

OpenTracing provides portable APIs for those adding instrumentation to their production systems.

To make life easier for those implementing monitoring and tracing tools, OpenTracing handles the time-consuming process of designing and maintaining featureful tracings APIs across programming languages while respecting their various idioms. This allows tracing tool implementors to focus on delivering value and making the most of the instrumented data itself.

In a codebase instrumented with OpenTracing, adding or switching to an OpenTracing-compatible tool becomes an `O(1)` operation for the programmer: it's just a configuration change - there's no need to modify the code instrumentation itself. Since the instrumentation process is often the greatest obstacle to adoption, building an OpenTracing-compatible implementation is a great way to get a monitoring and tracing tool into the hands of more developers more quickly.

### How to Add an OpenTracing Implementation

For information about current reference implementations on particular platforms, please reach out to the OpenTracing authors via [email](https://groups.google.com/forum/#!forum/distributed-tracing) or [gitter](https://gitter.im/opentracing/public).
