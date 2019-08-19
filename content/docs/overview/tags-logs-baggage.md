---
title: Tags, logs and baggage
weight: 4
---

## Tags

**Tags** are key:value pairs that enable user-defined annotation of spans in order to query, filter, and comprehend trace data.

Span tags should apply to the _whole_ span. There is a list available at [semantic_conventions.md](https://github.com/opentracing/specification/blob/master/semantic_conventions.md) listing conventional span tags for common scenarios. Examples may include tag keys like `db.instance` to identify a database host, `http.status_code` to represent the HTTP response code, or `error` which can be set to True if the operation represented by the Span fails.

## Logs

**Logs** are key:value pairs that are useful for capturing _timed_ log messages and other debugging or informational output from the application itself.  Logs may be useful for documenting a specific moment or event within the span (in contrast to tags which should apply to the span regardless of time).

## Baggage Items

The **SpanContext** carries data across process boundaries. Specifically, it has two major components:

- An implementation-dependent state to refer to the distinct span within a trace
    - i.e., the implementing Tracer's definition of spanID and traceID
- Any **Baggage Items**
    - These are key:value pairs that cross process-boundaries.
    - These may be useful to have some data available for access throughout the trace.
