---
layout: page
title: Implementing the OpenTracing APIs
---

OpenTracing makes tracing portable for those adding instrumentation to their production systems.

That said, it also makes life easier for those implementing monitoring and tracing tools: rather than spending time and effort learning the idioms of numerous platforms, designing featureful tracing APIs, and maintaining them, projects which implement OpenTracing can focus on delivering value and making the moste of the instrumented data.

Furthermore, in a codebase instrumented with OpenTracing, adding (or switching to) an OpenTracing-compatible tool is an `O(1)` operation for the programmer: it's really just a configuration change. Since instrumentation is often the greatest obstacle to adoption, OpenTracing support is a great way to put a moritoring and/or tracing tool in the hands of more developers quickly.

For information about current reference implementations in particular platforms, please reach out to the OpenTracing authors via [email](https://groups.google.com/forum/#!forum/distributed-tracing) or
[gitter](https://gitter.im/opentracing/public).
