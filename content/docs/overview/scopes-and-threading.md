---
title: "Scopes and Threading"
---
## Introduction

The OpenTracing API allows for only one `span` in a thread to be active at any point in time. There can be other spans involved with the same thread, which satisfy the following conditions:

- Started,
- Not finished,
- Not “active”.

There can be multiple spans on the same thread, if the spans are:

- Waiting for I/O,
- Blocked on a child Span or
- Off of the critical path

 A `Scope` formalizes the activation and deactivation of a `Span`. The `ScopeManager` API allows for a `Span` to be transferred to another thread or callback but not `Scope`. Further, it provides access to the active `Span`. This process has been described in detail below.

If a `Scope` exists when the developer creates a new `Span` then it will act as its parent, unless the programmer invokes `ignoreActiveSpan()` at `buildSpan()` time or specifies parent context explicitly.

## Accessing the Current Active Span
As it is inconvenient to pass an active `Span` from function to function manually, so OpenTracing requires that every `Tracer` contain a `ScopeManager`. A `ScopeManager` grants access to the active Span through a `Scope`. This means that a developer can access any active `Span` through a `Scope`.

## Moving a span between threads
Using the OpenTracing API, a developer can transfer the spans among different threads. A `Span`’s lifetime might start in one thread and end in another. Passing of scopes to another thread or callback is not supported.
The internal timing breakdown of a Span might look like as shown below.

[ ServiceHandlerSpan                                 ]
 |·FunctionA·|·····waiting on an RPC······|·FunctionB·|

---------------------------------------------------------> time

The “ServiceHandlerSpan” is active while it’s running in FunctionA and FunctionB, but remains inactive while waiting on an Remote Procedure Call (RPC). The RPC will presumably have a `Span` of its own, however, we are only concerned with the propagation of “ServiceHandlerSpan” from FunctionA to FunctionB.
Using the `ScopeManager` API it is possible to fetch the `span()` in FunctionA and re-activate it in FunctionB after RPC terminates. The steps are as below:

1. Start a Span via either `startManual` or `startActive(false)` to prevent the `Span` from being finished upon `Scope` deactivation.

2. Invoke `tracer.scopeManager().activate(span, false)` to re-activate the `Span` and get a new `Scope`, then `deactivate()` it when the `Span` is no longer active.

3. Where the end of the task is reached, invoke `tracer.scopeManager().activate(span, true)` to re-activate the `Span` and have the new `Scope` close the `Span` automatically.
