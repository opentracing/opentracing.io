---
title: "Scopes and Threading"
weight: 3
---
## Introduction

In any given thread there is an "active" span primarily responsible for the work accomplished by the surrounding application code, called the `ActiveSpan`. The OpenTracing API allows for only one `span` in a thread to be active at any point in time. This is managed using a `Scope`, which formalizes the activation and deactivation of a `Span`.

Other spans that are involved with the same thread will satisfy either of the following conditions:

- Started
- Not finished
- Not "active"

For example, there can be multiple spans on the same thread, if the spans are:

- Waiting for I/O
- Blocked on a child Span
- Off of the critical path

> Note that if a `Scope` exists when the developer creates a new `Span` then it will act as its parent, unless the programmer invokes `ignoreActiveSpan()` at `buildSpan()` time or specifies parent context explicitly.

## Accessing the Current Active Span
As it is inconvenient to pass an active `Span` from function to function manually, so OpenTracing requires that every `Tracer` contain a `ScopeManager`. The `ScopeManager` API grants access to the active Span through a `Scope`. This means that a developer can access any active `Span` through a `Scope`.

## Moving a span between threads
Using the `ScopeManager` API, a developer can transfer the spans among different threads. A `Span`’s lifetime might start in one thread and end in another. The `ScopeManager` API allows for a `Span` to be transferred to another thread or callback. Passing of scopes to another thread or callback is not supported. For more details, refer to the language specific documentation.
