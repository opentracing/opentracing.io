---
title: Spans
weight: 2
---

## What is a Span?

The "**span**" is the primary building block of a distributed trace, representing an individual unit of work done in a distributed system.

Each component of the distributed system contributes a span - a named, timed operation representing a piece of the workflow.

Spans can (and generally do) contain "References" to other spans, which allows multiple Spans to be assembled into one complete **Trace** - a visualization of the life of a request as it moves through a distributed system.

Each span encapsulates the following state according to the OpenTracing specification:

- An operation name
- A start timestamp and finish timestamp
- A set of key:value span **Tags**
- A set of key:value span **Logs**
- A **SpanContext**

#### Tags

**Tags** are key:value pairs that enable user-defined annotation of spans in order to query, filter, and comprehend trace data.

Span tags should apply to the _whole_ span. There is a list available at [semantic_conventions.md](https://github.com/opentracing/specification/blob/master/semantic_conventions.md) listing conventional span tags for common scenarios. Examples may include tag keys like `db.instance` to identify a database host, `http.status_code` to represent the HTTP response code, or `error` which can be set to True if the operation represented by the Span fails.

#### Logs

**Logs** are key:value pairs that are useful for capturing _span-specific_ logging messages and other debugging or informational output from the application itself.  Logs may be useful for documenting a specific moment or event within the span (in contrast to tags which should apply to the span as a whole).

#### SpanContext

The **SpanContext** carries data across process boundaries. Specifically, it has two major components:

- An implementation-dependent state to refer to the distinct span within a trace
    - i.e., the implementing Tracer's definition of spanID and traceID
- Any [**Baggage Items**](/docs/overview/tags-logs-baggage)
    - These are key:value pairs that cross process-boundaries.
    - These may be useful to have some data available for access throughout the trace.


#### Example Span:


```
    t=0            operation name: db_query               t=x

     +-----------------------------------------------------+
     | · · · · · · · · · ·    Span     · · · · · · · · · · |
     +-----------------------------------------------------+

Tags:
- db.instance:"jdbc:mysql://127.0.0.1:3306/customers
- db.statement: "SELECT * FROM mytable WHERE foo='bar';"

Logs:
- message:"Can't connect to mysql server on '127.0.0.1'(10061)"

SpanContext:
- trace_id:"abc123"
- span_id:"xyz789"
- Baggage Items:
  - special_id:"vsid1738"
```
