# Data Conventions

## Background

OpenTracing defines an API through which application instrumentation can log data to a pluggable tracer. In general, there is no guarantee made by OpenTracing about the way that data will be handled by an underlying tracer. So what type of data should be provided to the APIs in order to best ensure compatibility across tracer implementations?

A high-level understanding between the instrumentor and tracer developers adds great value: if certain known tag key/values are used for common application scenarios, tracers can choose to pay special attention to them. The same is true of `log`ged events, and span structure in general.

As an example, consider the common case of a HTTP-based application server. The URL of an incoming request that the application is handling is often useful for diagnostics, as well as the HTTP verb and the resultant status code. An instrumentor could choose to report the URL in a tag named `URL`, or perhaps named `http.url`: either would be valid from the pure API perspective. But if the Tracer wishes to add intelligence, such as indexing on the URL value or sampling proactively for requests to a particular endpoint, it must know where to look for relevant data. In short, when tag names and other instrumentor-provided values are used consistently, the tracers on the other side of the API can employ more intelligence.

The guidelines provided here describe a common ground on which instrumentors and tracer authors can build beyond pure data collection. Adherence to the guidelines is optional but highly recommended for instrumentors.

## `data_conventions.yaml`

The complete list of standard instrumentation can be found in the [`specification`](https://github.com/opentracing/specification) repository's [`data_conventions.yaml`](https://github.com/opentracing/specification/blob/master/data_conventions.yaml) file.

If you see an opportunity for additional standardization, please [file an issue against the `specification` repository](https://github.com/opentracing/specification/issues/new) or raise the point on [OpenTracing's public Gitter channel](https://gitter.im/opentracing/public).
