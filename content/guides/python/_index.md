---
title: Python
weight: 15
---

The work of instrumentation libraries generally consists of three steps:

1. When a service receives a new request (over HTTP or some other protocol),
   it uses OpenTracing's inject/extract API to continue an active trace, creating a
   Span object in the process. If the request does not contain an active trace,
   the service starts a new trace and a new *root* Span.
2. The service needs to store the current Span in some request-local storage,
   (called ``Span`` *activation*) where it can be retrieved from when a child Span must
   be created, e.g. in case of the service making an RPC to another service.
3. When making outbound calls to another service, the current Span must be
   retrieved from request-local storage, a child span must be created (e.g., by
   using the ``start_child_span()`` helper), and that child span must be embedded
   into the outbound request (e.g., using HTTP headers) via OpenTracing's
   inject/extract API.

Below are the code examples for the previously mentioned steps. Implementation
of request-local storage needed for step 2 is specific to the service and/or frameworks /
instrumentation libraries it is using, exposed as a ``ScopeManager`` child contained
as ``Tracer.scope_manager``. See details below.

## Inbound request

Somewhere in your server's request handler code:
```py
   def handle_request(request):
       span = before_request(request, opentracing.global_tracer())
       # store span in some request-local storage using Tracer.scope_manager,
       # using the returned `Scope` as Context Manager to ensure
       # `Span` will be cleared and (in this case) `Span.finish()` be called.
       with tracer.scope_manager.activate(span, True) as scope:
           # actual business logic
           handle_request_for_real(request)


   def before_request(request, tracer):
       span_context = tracer.extract(
           format=Format.HTTP_HEADERS,
           carrier=request.headers,
       )
       span = tracer.start_span(
           operation_name=request.operation,
           child_of(span_context))
       span.set_tag('http.url', request.full_url)

       remote_ip = request.remote_ip
       if remote_ip:
           span.set_tag(tags.PEER_HOST_IPV4, remote_ip)

       caller_name = request.caller_name
       if caller_name:
           span.set_tag(tags.PEER_SERVICE, caller_name)

       remote_port = request.remote_port
       if remote_port:
           span.set_tag(tags.PEER_PORT, remote_port)

       return span
```

### Outbound request


Somewhere in your service that's about to make an outgoing call:

```py
   from opentracing import tags
   from opentracing.propagation import Format
   from opentracing_instrumentation import request_context

   # create and serialize a child span and use it as context manager
   with before_http_request(
       request=out_request,
       current_span_extractor=request_context.get_current_span):

       # actual call
       return urllib2.urlopen(request)


   def before_http_request(request, current_span_extractor):
       op = request.operation
       parent_span = current_span_extractor()
       outbound_span = opentracing.global_tracer().start_span(
           operation_name=op,
           child_of=parent_span
       )

       outbound_span.set_tag('http.url', request.full_url)
       service_name = request.service_name
       host, port = request.host_port
       if service_name:
           outbound_span.set_tag(tags.PEER_SERVICE, service_name)
       if host:
           outbound_span.set_tag(tags.PEER_HOST_IPV4, host)
       if port:
           outbound_span.set_tag(tags.PEER_PORT, port)

       http_header_carrier = {}
       opentracing.global_tracer().inject(
           span_context=outbound_span,
           format=Format.HTTP_HEADERS,
           carrier=http_header_carrier)

       for key, value in http_header_carrier.iteritems():
           request.add_header(key, value)

       return outbound_span
```

# Scope and within-process propagation

For getting/setting the current active ``Span`` in the used request-local storage,
OpenTracing requires that every ``Tracer`` contains a ``ScopeManager`` that grants
access to the active ``Span`` through a ``Scope``. Any ``Span`` may be transferred to
another task or thread, but not ``Scope``.

```py
       # Access to the active span is straightforward.
       scope = tracer.scope_manager.active()
       if scope is not None:
           scope.span.set_tag('...', '...')
```

The common case starts a ``Scope`` that's automatically registered for intra-process
propagation via ``ScopeManager``.

Note that ``start_active_span('...')`` automatically finishes the span on ``Scope.close()``
(``start_active_span('...', finish_on_close=False)`` does not finish it, in contrast).

```py
       # Manual activation of the Span.
       span = tracer.start_span(operation_name='someWork')
       with tracer.scope_manager.activate(span, True) as scope:
           # Do things.

       # Automatic activation of the Span.
       # finish_on_close is a required parameter.
       with tracer.start_active_span('someWork', finish_on_close=True) as scope:
           # Do things.

       # Handling done through a try construct:
       span = tracer.start_span(operation_name='someWork')
       scope = tracer.scope_manager.activate(span, True)
       try:
           # Do things.
       except Exception as e:
           scope.set_tag('error', '...')
       finally:
           scope.finish()
```

**If there is a Scope, it will act as the parent to any newly started Span** unless
the programmer passes ``ignore_active_span=True`` at ``start_span()``/``start_active_span()``
time or specified parent context explicitly:

```py
       scope = tracer.start_active_span('someWork', ignore_active_span=True)
```

Each service/framework ought to provide a specific ``ScopeManager`` implementation
that relies on their own request-local storage (thread-local storage, or coroutine-based storage
for asynchronous frameworks, for example).

## Scope managers

This project includes a set of ``ScopeManager`` implementations under the ``opentracing.scope_managers`` submodule, which can be imported on demand:

```py
   from opentracing.scope_managers import ThreadLocalScopeManager
```

There exist implementations for ``thread-local`` (the default), ``gevent``, ``Tornado`` and ``asyncio``:

```py
   from opentracing.scope_managers.gevent import GeventScopeManager # requires gevent
   from opentracing.scope_managers.tornado import TornadoScopeManager # requires Tornado
   from opentracing.scope_managers.asyncio import AsyncioScopeManager # requires Python 3.4 or newer.
```