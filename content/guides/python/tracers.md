---
title: "Python: Tracers"
---

## Setting up your Tracer
A `Tracer` is the actual implementation that will record the `Spans` and publish them somewhere. Python `Tracer` implementation defines both the public Tracer API and provides a default no-op behavior.
Different `Tracer` implementations vary in how and what parameters they receive at initialization time, such as:
- Component name for this application's traces.
- Tracing endpoint.
- Tracing credentials.
- Sampling strategy.
For example, initializing the `Tracer` implementation of Jaeger might look like this:

```python
import logging
from jaeger_client import Config

def init_tracer(service):
    logging.getLogger('').handlers = []
    logging.basicConfig(format='%(message)s', level=logging.DEBUG)

    config = Config(
        config={
            'sampler': {
                'type': 'const',
                'param': 1,
            },
            'logging': True,
        },
        service_name=service,
    )

    # this call also sets opentracing.tracer
    return config.initialize_tracer()
```

To use this instance, replace `opentracing.tracer` with `init_tracer(...)`:

`tracer = init_tracer('hello-world')`

Once a `Tracer` instance is obtained, it can be used to manually create `Span`. This can be done in two ways:

1. `Tracer.start_active_span()` creates a new `Span` and automatically activates it.

2. `Tracer.start_span()` creates a new `Span`

Note `tracer.start_span()` and `Tracer.start_active_span()` will automatically use the current active `Span` as a parent, unless the programmer passes a specified parent context or sets `ignore_active_span=True`.

Complete tutorial is available [here](https://github.com/yurishkuro/opentracing-tutorial/tree/master/python/lesson01).
