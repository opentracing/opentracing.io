---
title: What is Distributed Tracing?
weight: 1
---

Distributed tracing, also called distributed request tracing, is a method used to profile and monitor applications, especially those built using a microservices architecture. Distributed tracing helps pinpoint where failures occur and what causes poor performance.

## Who Uses Distributed Tracing?

IT and DevOps teams can use distributed tracing to monitor applications.  Distributed tracing is particularly well-suited to debugging and monitoring modern distributed software architectures, such as microservices.

Developers can use distributed tracing to help debug and optimize their code.

## What is OpenTracing?

It is probably easier to start with what OpenTracing is NOT.

* OpenTracing is not a download or a program.  Distributed tracing requires that software developers add instrumentation to the code of an application, or to the frameworks used in the application.

* OpenTracing is not a standard. The Cloud Native Computing Foundation (CNCF) is not an official standards body.  The OpenTracing API project is working towards creating more standardized APIs and instrumentation for distributed tracing.

OpenTracing is comprised of an API specification, frameworks and libraries that have implemented the specification, and documentation for the project.   OpenTracing allows developers to add instrumentation to their application code using APIs that do not lock them into any one particular product or vendor.

For more information about where OpenTracing has already been implemented, see the [list of languages](/docs/supported-languages) and the  [list of tracers](/docs/supported-tracers) that support the OpenTracing specification.

## Concepts and Terminology

All language-specific OpenTracing APIs share some core concepts and terminology. These concepts are so central and important to the project that they have their own repository ([github.com/opentracing/specification](https://github.com/opentracing/specification)) and semver scheme.

1. The [OpenTracing Semantic Specification](https://github.com/opentracing/specification/blob/master/specification.md) is a versioned description of the current pan-language OpenTracing standard
1. The [Semantic Conventions](https://github.com/opentracing/specification/blob/master/semantic_conventions.md) spec describes conventional Span tags and log keys for common semantic scenarios

Both files are versioned and the GitHub repository is tagged according to the rules described by [the versioning policy](https://github.com/opentracing/specification/blob/master/specification.md#versioning-policy).
