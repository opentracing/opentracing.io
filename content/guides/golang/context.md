---
title: "Context"
underConstruction: true
weight: 3
---

* Using Context
  * Adding a span to a context
  * Accessing a span from a Context
  * Contexts are immuutable, spans are not
  * Watch out for nil
* Deadlines and Spans
  * Finishing Spans on Deadlines
  * Do not Cancel contexts based on span finish
* When not to use context
  * Tracing Long-lived Objects
* Higher level APIs
  * Context-only APIs
    * StartSpanFromContext(ctx context.Context, operationName string, opts ...StartSpanOption) (Span, context.Context)
    * Tag(context.Context)
    * Log(context.Context)
