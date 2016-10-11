# Data Conventions

## Introduction

OpenTracing defines an API through which application instrumentation can log data to a pluggable tracer. In general, there is no guarantee made by OpenTracing about the way that data will be handled by an underlying tracer. So what type of data should be provided to the APIs in order to best ensure compatibility across tracer implementations?

A high-level understanding between the instrumentor and tracer developers adds great value: if certain known tag key/values are used for common application scenarios, tracers can choose to pay special attention to them. The same is true of `log`ged events, and span structure in general.

As an example, consider the common case of a HTTP-based application server. The URL of an incoming request that the application is handling is often useful for diagnostics, as well as the HTTP verb and the resultant status code. An instrumentor could choose to report the URL in a tag named `URL`, or perhaps named `http.url`--either would be valid from the pure API perspective. But if the Tracer wishes to add intelligence, such as indexing on the URL value or sampling proactively for requests to a particular endpoint, it must know where to look for relevant data. In short, when tag names and other instrumentor-provided values are used consistently, the tracers on the other side of the API can employ more intelligence.

The guidelines provided here describe a common ground on which instrumentors and tracer authors can build beyond pure data collection. Adherence to the guidelines is optional but highly recommended for instrumentors.



## Spans


### Span Naming

Spans carry tags, logs, and baggage, but they also have a top-level **operation name**. This should be a low-cardinality string value representing the type of work being done in the span. Typically, this is the local type of work being done. Examples include an RPC or endpoint name for a HTTP span, `SELECT` or `INSERT` for a SQL span, and so on.

Secondarily, an optional **component** tag can be provided to scope the operation name. Typically, a process, framework, library, or module name is a good guideline for the component tag.

### Span Structure

Span structure is also important: what do spans represent, and what relationship do they have towards their ancestors?  This is covered in the [Semantic Specification](/pages/spec).


## Span Tag Use-Cases

The following tags are recommended for instrumentors who are trying to represent a particular type of data. Tag names follow a general structure of namespacing.

The recommended tags below are accompanied by `const` values included in an `ext` module for each opentracing implementation.  These `ext` values should be used in place of the strings below, as tracers may choose to use different underlying representations for these common concepts.  The symbols are similar in each implementation: ([Go](https://github.com/opentracing/opentracing-go/blob/master/ext/tags.go), [Python](https://github.com/opentracing/opentracing-python/blob/master/opentracing/ext/tags.py), etc.)

Some tags mentioned below may contain values of significant size. Handling of such values is implementation-specific: it is the responsibility of the Tracer to honor, drop, or truncate these tags as appropriate. However, care should be exercised on the part of the instrumentor, as even the generation or passing of such values to the Tracer may create undesirable overhead for the application.

It is not required that all suggested tags be used, even if one is used.

### Errors

The error state of a span instance should be represented as a tag.

* `error` - bool
    - `true` means that the span is in an error state
    - `false` or the absence of an `error` tag means that the span is not in an error state

### Component Identification

For any span, it can be useful to specify the type of component being instrumented. This is particularly recommended for instrumentation provided for libraries or modules, where end-users may have a mix of custom and library-provided instrumentation.

* `component` - string
    - Low-cardinality identifier of the module, library, or package that is instrumented.
    - Examples:
        - `httplib` for instrumentation of Python builtin httplib functionality
        - `JDBC` for instrumentation of JDBC database connectors
        - `mongoose` for instrumentation of Ruby MongoDB client connector
* `span.kind` - string
    - One of `client` or `server`, indicating if this span represents a client or server

### HTTP Server Tags

These tags are recommended for spans marking entry into a HTTP-based service.

* `http.url` - string
    - URL of the request being handled in this segment of the trace, in [standard URI format](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier).
    - Protocol optional
    - Examples:
        - `https://domain.net/path/to?resource=here`
        - `domain.net/path/to/resource`
        - `http://user:pass@domain.org:8888`
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
    - Value of `server` should be used to indicate that this is a server-side span (see "<a href="#component-identification">Component Identification</a>")


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

### Sampling

OpenTracing API does not enforce the notion of sampling, but most implementation do use it in one form or another. Sometimes the application needs to give a hint to the tracer that it would like to have a particular trace recorded in storage even if the normal sampling says otherwise. The `sampling.priority` tag is used to provide such hint. Tracing implementations are not required to respect the hint, but most will do their best to preserve the trace.

* `sampling.priority` - integer
    - If greater than 0, a hint to the tracer to do its best to capture the trace.
    - If 0, a hint to the tracer to not capture the trace.
    - If this tag is not provided, the tracer should use its default sampling mechanism.

