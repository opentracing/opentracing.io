---
title: Dec. 2018 - Mar. 2019
weight: 20
---

# Outreachy

The OpenTracing and Jaeger projects are happy to announce our participation in the Outreachy program, running
from December 2018 to March 2019. 

Please see the main [program page](https://outreachy.org) for the general information about the program, such
as its purpose, timeline, eligibility requirements, and how to apply.

## What is OpenTracing

OpenTracing is a vendor-neutral open standard for distributed tracing. For the motivation behind OpenTracing,
we recommend watching the presentations available at the page [Talks and Videos](/media).

## What is Jaeger

Jaeger is a concrete set of tracers and a trace storage backend, for usage on applications and microservices
instrumented with OpenTracing. Its [GitHub main readme](https://github.com/jaegertracing/jaeger) is a good
starting point to understand what is Jaeger and how to start using it.

## Schedule
- End of October: - application deadline
- November: - selection decisions are made
- December to March: - internship

## Coordination

* [Juraci Paixão Kröhling](https://github.com/jpkrohling)

The coordinators can be contacted at any time. The easiest way is to send a message to the mailing list of either
OpenTracing or Jaeger:

* [OpenTracing Mailing List](https://groups.google.com/forum/#!forum/opentracing)
* [Jaeger Mailing List](https://groups.google.com/forum/#!forum/jaeger-tracing)

Another option is to use Gitter, which is the chat platform used by both the OpenTracing and Jaeger projects:

* [OpenTracing Gitter Channel](http://gitter.im/opentracing/public)
* [Jaeger Gitter Channel](https://gitter.im/jaegertracing/Lobby)

## Mentors

* [Juraci Paixão Kröhling](https://github.com/jpkrohling)

Similar to contacting the coordinators, the mentors can be contacted at any time either by sending messages to
the mailing lists or Gitter channels.

Interested in becoming a mentor? Contact one of the coordinators!

Do you have an idea for a task that is suitable for this program? Contact the mentors or coordinators! Or
even better, volunteer for mentoring an intern to work on your idea!

## Contribute

As part of the application process, the Outreachy program recommends that candidates make 
[small contributions](https://www.outreachy.org/apply/make-contributions/) to the project they intend to apply for.

For this round, we have three possible areas interns can work on.

* [Create a set of performance tests](https://www.outreachy.org/december-2018-march-2019-outreachy-internships/communities/cncf-tracing/#create-a-set-of-performance-tests)
* [Research the gaps in tracing mobile clients](https://www.outreachy.org/december-2018-march-2019-outreachy-internships/communities/cncf-tracing/#research-the-gaps-in-tracing-mobile-clients)
* [Research the gaps in tracing web clients](https://www.outreachy.org/december-2018-march-2019-outreachy-internships/communities/cncf-tracing/#research-the-gaps-in-tracing-web-clients)

### Create a set of performance tests

One of the questions that are always asked after presenting OpenTracing and Jaeger is: what’s the performance overhead? So far, we don’t have a great answer to that and you’ll help us change that!

This project is all about performance measurement: you’ll be responsible for creating a set of performance tests and frameworks to measure and assess the performance of:

* OpenTracing instrumentation libraries, such as JAX-RS, Spring Cloud, CDI, …​ with and without a concrete tracer (NoopTracer)
* Jaeger Client Java
* Jaeger Agent
* Jaeger Collector with different storage backends (Cassandra, Elasticsearch, Kafka, in-memory)
* Jaeger Query with different storage backends

At the end of the internship, you’ll have a deep understanding of all the pieces that form a modern distributed tracing platform, as well as best practices in the world of Quality Engineering, especially regarding performance tests.

Your mentor will be Juraci Paixão Kröhling, Software Engineer at Red Hat and maintainer on the Jaeger project.

Interested in this project? Here are a few tasks that might help you decide. If you get one or more of them done, make sure to mention it during the application process: https://git.io/fACHE

### Research the gaps in tracing mobile clients

Distributed Tracing has the potential to uncover bugs and performance problems across an application’s stack, but user interface technologies are notably behind, such as mobile clients.

This project is about researching what are the missing pieces to get mobile (Android) clients to join or start traces that are part of a distributed trace. You’ll be responsible for building prototypes and experiments using a mix of technologies, such as:

* Android
* OpenTracing
* Jaeger

At the end of the internship, you’ll have a good understanding of distributed tracing and how all pieces fit together.

Your mentor will be Juraci Paixão Kröhling, Software Engineer at Red Hat and maintainer on the Jaeger project.

Interested in this project? Here are a few tasks that might help you decide. If you get one or more of them done, make sure to mention it during the application process: https://git.io/fACH2

### Research the gaps in tracing web clients

Distributed Tracing has the potential to uncover bugs and performance problems across an application stack, but user interface technologies are notably behind, such as web clients.

This project is about researching what are the missing pieces to get web clients to securely join or start traces that are part of a distributed trace. You’ll be responsible for building prototypes and experiments using a mix of technologies, such as:

* JavaScript
* Web security best practices
* OpenTracing
* Jaeger

At the end of the internship, you’ll have a great understanding in building trusted communication over untrusted channels, as well as distributed tracing.

Your mentor will be Juraci Paixão Kröhling, Software Engineer at Red Hat and maintainer on the Jaeger project.

Interested in this project? Here are a few tasks that might help you decide. If you get one or more of them done, make sure to mention it during the application process: https://git.io/fACHw

## Previous programs

OpenTracing and Jaeger participated in the following Outreachy programs:

* [December 2017 to March 2018](/get-involved/outreachy/outreachy-201701)
* [May 2018 to August 2018](/get-involved/outreachy/outreachy-201801)

## Code of Conduct

Both OpenTracing and Jaeger are part of the Cloud Native Computing Foundation (CNCF) and have adopted its
[Code of Conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md).