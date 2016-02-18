---
layout: page
title: Per-Platform APIs
---
OpenTracing APIs are **available** for the following platforms:

* Go ([1.0RC](#v1rc)) - [https://github.com/opentracing/opentracing-go](https://github.com/opentracing/opentracing-go)
* Python ([1.0RC](#v1rc)) - [https://github.com/opentracing/opentracing-python](https://github.com/opentracing/opentracing-python)

OpenTracing APIs are **in progress** for the following platforms:

* Javascript - [https://github.com/opentracing/opentracing-javascript](https://github.com/opentracing/opentracing-javascript)
* Java - [https://github.com/opentracing/opentracing-java](https://github.com/opentracing/opentracing-java)

Please refer to the README files in the respective per-platform repositories for usage examples.

PHP, iOS, and Ruby are next on our list, though community contributions are welcome for other languages at any time.

<div id="v1rc"></div>

### What does "1.0RC" mean?

It means that the contributors have spent a while thinking through the APIs from above and below, prototyped bindings to several tracing systems and many calling contexts, and have settled on the scope and exposed by the various OpenTracing APIs.

1.0RC means that we feel comfortable formally binding OpenTracing to production tracing systems and production application code: not just in dev branches, but in public PRs. Once those bindings have been vetted in real production environments (and any adjustments or additions made to OpenTracing as a result) we will announce OpenTracing 1.0.
