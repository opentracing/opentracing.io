---
title: "Java: Scopes"
---

#### Setting a ScopeManager

Setting the **Tracer**'s **ScopeManager** to handle the active **Span** should be a one-time operation, and hence most of the time should be provided at construction time:

```java
  import io.opentracing.ScopeManager;
  import io.opentracing.Tracer;

  ScopeManager scopeManager = new ScopeManagerImpl();
  Tracer tracer = new CustomTracer(..., scopeManager);
```

However, in most of the cases **Tracer** implementations will provide a sensible, useful, default choice, and the user will not need to provide one himself (for example, a common default is **opentracing.util.ThreadLocalScopeManager**, which stores the active **Span** in thread-local storage).

The user only needs to provide the **ScopeManager** manually when specialized behavior is needed, such as leveraging referencing count for handling **Span** lifetime for instrumenting asynchronous frameworks (Akka or Play, for instance).

#### Scope objects.

**Scope** objects act as containers of the current active **Span**, implementing the **Closeable** interface to be signaled when they should stop being the active instance for the current context (usually a thread), and optionally closing the contained **Span** along the way (this is specified through a **finishOnClose** parameter for the related methods).

**Tracer.SpanBuilder.startActiveSpan(boolean finishOnClose)** will create a new **Span** and will automatically set is as the active one for the current context.

```java
  import io.opentracing.Scope;

  // Strongly encouraged to use them under try statements,
  // to prevent ending up with the incorrect active Span
  // in case of error.
  try (Scope scope = tracer.buildSpan("foo").startActive(true)) {
    scope.span().setTag(...);
    scope.span().log(...);
  }

  // The 'foo' Span is finished at this point.
```

Automatically any active **Span** will be used as parent of newly created **Spans** (through either **start()** or **startActive()**), without need to explicitly specify the relationship:

```java
  try (Scope scope = tracer.buildSpan("parent").startActive()) {
    try (Scope scope = tracer.buildSpan("child").startActive()) {
      // "child" is automatically a child of "parent".
    }
  }
```

It is possible the override this behavior, and explicitly provide a parent:

```java
  Span parent = getRequestSpan();
  try (Scope scope = tracer.buildSpan("foo")
                      .asChildOf(parent)
                      .startActive(true)) {
  }
```

And it is also possible to totally ignore any active **Span** (thus creating a parentless instance):

```java
  try (Scope scope = tracer.buildSpan("foo")
                      .ignoreActiveSpan()
                      .startActive(true)) {
  }
```

Finally, **Tracer.activeSpan()** exposed the active **Span** for the current context, returning `null` if none is set at the moment.

```java
  if (tracer.activeSpan() != null) {
    tracer.activeSpan().setTag(...);
  }
```

#### Advanced usage

Most of the time the user will want to deactivate and finish the **Span** at the same time. However, there are cases when the user may need to set it as active only temporary (in code using callbacks in a thread pool, or acting as part of a middleware layer, for example). For this, **finishSpanOnClose** can be set to `false`:

```java
  try (Scope scope = tracer.buildSpan("foo").startActive(false)) {
    anotherFunction();
  }

  // The 'foo' Span will be finished at this point.
```

However, most of the times an already existing **Span** will be activated instead, and this can be done through **ScopeManager.activate(boolean finishOnClose)** directly:

```java
  void callbackHandler(Span span) {
    try (Scope scope = tracer.scopeManager().activate(span, false) {
      scope.span().log(...);
    }
  }
```

When the operation finally reaches its end, the **Span** could be directly finished through **Span.finish()**, or by using **ScopeManager.activate(false)**).

#### Thread Safety

At the moment of writing this, the Specification is still not making mention of **ScopeManager** nor of its related siblings. However, it is expected that **ScopeManager** is safe to be used from different threads, while **Scope** is not - this is because, in Java, **Scope** represents the active state for the current context (usually a thread), which cannot be naturally, automatically propagated to other contexts (usually other threads).

Consider passing **Span** instances between threads, or else create a new one for each operation happening in a different thread.
