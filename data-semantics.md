---
layout: page
title: Data Semantics Guidelines
---
<div id="toc"></div>

## Introduction

OpenTracing defines an API through which application instrumentation can log data to a pluggable tracer. In general, there is no guarantee made by OpenTracing about the way that data will be handled by an underlying tracer. That said, the APIs are by design open-ended: what type of data should be provided to them?

A general understanding between the instrumentor and tracer developers adds great value: if certain known tag key/values are used for common application scenarios, tracers can choose to pay special attention to them. The same is true of `log`ged events, and span structure in general.

As an example, consider the common case of a HTTP-based application server. The URL of an incoming request that the application is handling is often useful for diagnostics, as well as the HTTP verb and the resultant status code. An instrumentor could choose to report the URL in a tag named `URL`, or perhaps named `http.url`--either would be valid from the pure API perspective. But if the Tracer wishes to add intelligence, such as indexing on the URL value or sampling proactively for requests to a particular endpoint, it must know where to look for relevant data. In short, when tag names and other instrumentor-provided values are used consistently, the tracers on the other side of the API can employ more intelligence.

The guidelines contained describe a common ground on which instrumentors and tracer authors can build beyond pure data collection. Adherence to the guidelines is optional but highly recommended for instrumetors.



## Spans


### Span Naming

Spans carry tags, logs, and attributes, but they also have a top-level **operation name**. This should be a low-cardinality string value representing the type of work being done in the span. Typically, a process, framework, library, or module name is a good guideline.

### Span Structure

Span structure is also important: what do spans represent, and what relationship do they have towards their parent span?  This is covered in the [Semantic Specification](/spec).


## Span Tag Use-Cases

The following tags are recommended for instrumentors who are trying to represent a particular type of data. Tag names follow a general structure of namespacing; the values are determined purely on a tag-by-tag basis.

The ecommended tags below are accompanied by `const` values included in an `ext` module for each opentracing implementation.  These `ext` values should be used in place of the strings below, as tracers may choose to use different underlying representations for these common concepts.

Some tags mentioned below may contain values of significant size. Handling of such values is implementation-specific: it is the responsibility of the Tracer to honor, drop, or truncate these tags as appropriate. However, care should be exercised on the part of the instrumentor, as even the generation or passing of such values to the Tracer may create undesirable overhead for the application.

It is not required that all specified tags be used, even if one is used.


### HTTP Server Tags

These tags are recommended for spans marking entry into a HTTP-based service.

* `http.url` - string
    - URL of the request being handled in this segment of the trace, in [standard URI format](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier), excepting query string parameters.
    - Protocol optional
    - Examples:
        - `https://domain.net/path/to?resource=here`
        - `domain.net/path/to/resource`
        - `http://user:pass@domain.org:8888`
* `http.query` - string
    - Query string parameters of the request being handled.
    - Note that the preceding `?` character is not expected.
    - Examples:
        - `key=val&key2=val2`
* `http.method` - string
    - HTTP method of the request being handled.
    - Case-insensitive
    - Examples:
        - `GET`, `POST`, `HEAD`
* `http.status_code` - integer
    - HTTP status code to be returned with HTTP response.
    - Examples:
        - `200`, `503`
* `span.kind` - string
    - Value of `s` should be used to indicate that this is a server side span (see "Peer Tags")


### Peer Tags

These tags can be provided by either client-side or server-side to describe the downstream (client case) or upstream (server case) peer being communicated with.

* `peer.hostname` - string
    - Remote hostname
* `peer.ipv4` - string
    - Remote IP v4 address
* `peer.ipv6` - string
    - Remote IP v6 address
* `peer.port` - integer
    - Remote port
* `peer.service` - string
    - Remote service name
* `span.kind` - string
    - One of `c` or `s`, indicating if this span represents a client or server



## Semantic Log Use-Cases

Some events are point-in-time and do not apply to an entire span; these are reported via logged events.  For instance, an error or exception may be reported via a `log` call.


### Exception

* Event: `exception`
* Payload:
    - `type` - string
        - Low-cardinality class of exception
    - `message` - string
        - Details associated with particular instance of this exception
    - `backtrace` - string
        - Stack trace provided at exception time
