---
title: "Python: Quick Start"
---

# Installing an OpenTracing Platform

In order to see and ship our traces, we'll first need to have a place to send them to and then visualize the results.

For this Quickstart guide, we'll begin by using the Jaeger platform, and their helpful Docker image. If you're using another platform, most everything else in this document will still apply, other than your initial configuration of where the tracer is.

So, if you've got Docker already installed, you can just run the following command in your terminal:

```bash
$ docker run -d -p5775:5775/udp -p6831:6831/udp -p6832:6832/udp -p5778:5778 -p16686:16686 -p14268:14268 -p9411:9411 jaegertracing/all-in-one:0.8.0
```

... and once the container spins up,the Jaeger UI will be at [http://localhost:16686](http://localhost:16686). You should now be ready to start sending traces to your local computer. 

# Installing an OpenTracing Library for Python

With the Jaeger server running, we've now got a place to ship our traces to. We'll now need to set up Python to be able to ship traces.

For our example, we'll start with the [Jaeger Python bindings](https://github.com/jaegertracing/jaeger-client-python) of OpenTracing. The binding is installable with `pip`:

```bash
$ pip install jaeger-client
```

>**Wait, why am I not installing opentracing-python?!**

>Again, [opentracing-python](https://github.com/opentracing/opentracing-python) is just a reference API. It's up to the shipping platforms themselves to implement and extend the API to ship to their APIs. 

Since we're using Jaeger, we'll use Jaeger's library to ship our traces.

But if we were using Datadog's APM, or Lightstep's tracer, we'd use their libraries instead.

Finally, since we're just playing around with sending traces, let's use an `iPython` shell to interactively send traces by hand. To install `iPython`, it's just another:

```bash
$ pip install ipython
```

Followed by typing `ipython` in a shell.

Now we have a way to ship our Traces from Python, and can jump in and configure a program to be instrumented.

Let's do that now. We'll initialize and configure Jaeger's Python bindings to ship to our local Docker container:

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

You can copy the above text and paste it into iPython's interactive shell with a `%paste`.

Next, we initialize this tracer, by creating sending the name of our new service to trace:

```python
tracer = init_tracer('first-service')
```

With this, we can then ship our first trace, using a context:

```python
with tracer.start_span('first-span') as span:
    span.set_tag('first-tag', '100')
```

Typing these lines into the iPython session, we should then see a line that says the span is being reported. 

Next, we can reload the Jaeger page at localhost, and see our service in the list of services, along with the trace and span.

From here, we can start to poke around at the edges of the OpenTracing API, and understand how things work. What happens if we start a `span` within another span? Just type it out and try it. See what changes in the Jaeger dashboard.

```
with tracer.start_span('second-span') as span2:
    span2.set_tag('second-tag', '90')
    with tracer.start_span('third-span') as span3:
        span3.set_tag('third-tag', '80')
```

If we look in the Jaeger dashboard, we can see our three spans show up separately. There is no link between the spans as we set them. This is because in order to link our `span`s, we need to set them up as child spans.

# Creating A Child Span 

Creating a child is done by creating tracer span as a `child_of` the parent span. Let's try that now, and see how it changes our `span`s in Jaeger:

```python
with tracer.start_span('fourth-span') as span4:
    span4.set_tag('fourth-tag', '60')
    with tracer.start_span('fifth-span', child_of=span4) as span5:
        span5.set_tag('fifth-tag', '80')
```

After running this code in our `ipython` repl, we can now go into Jaeger, and see our `fifth-span` successfully made a child of `fourth-span`. 

Try putting some delays between our `span`s to see how this affects your timeline. You'll start to get a feel for how spans show different delays of time.

In order to link our two spans, 
* Link to Python walkthroughs / tutorials
* Setting up your tracer
* Start a Trace
* Create a Child Span
* Make An HTTP request
* View your trace
