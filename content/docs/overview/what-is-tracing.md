---
title: "What is Distributed Tracing?"
---

# Concepts and Terminology

All language-specific OpenTracing APIs share core concepts and terminology. These concepts are so central and important to the project that they have their own repository ([github.com/opentracing/specification](https://github.com/opentracing/specification)) and semver scheme.

This `specification` repository houses two important files:

1. [`specification.md`](https://github.com/opentracing/specification/blob/master/specification.md) is a versioned description of the current pan-language OpenTracing standard
1. [`semantic_conventions.md`](https://github.com/opentracing/specification/blob/master/semantic_conventions.md) describes conventional Span tags and log keys for common semantic scenarios

Both are versioned and the github repository is tagged according to the rules described by [the versioning policy](https://github.com/opentracing/specification/blob/master/specification.md#versioning-policy).

# OpenTracing Language Support

OpenTracing APIs are available for the following platforms:

* Go - [opentracing-go](https://github.com/opentracing/opentracing-go)
* Python - [opentracing-python](https://github.com/opentracing/opentracing-python)
* Javascript - [opentracing-javascript](https://github.com/opentracing/opentracing-javascript)
* Java - [opentracing-java](https://github.com/opentracing/opentracing-java)
* C# - [opentracing-csharp](https://github.com/opentracing/opentracing-csharp)
* Objective-C - [opentracing-objc](https://github.com/opentracing/opentracing-objc)
* C++ - [opentracing-cpp](https://github.com/opentracing/opentracing-cpp)
* Ruby - [opentracing-ruby](https://github.com/opentracing/opentracing-ruby)
* PHP - [opentracing-php](https://github.com/opentracing/opentracing-php)

Please refer to the README files in the respective per-platform repositories for usage examples.

Community contributions are welcome for other languages at any time.