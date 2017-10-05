---
permalink: /outreachy.html
layout: page-containing-markup
title: 'Outreachy'
---

# Outreachy

The OpenTracing and Jaeger projects are happy to announce our participation in the Outreachy program, running
from December 2017 to March 2018. As part of this joint effort, we'll be collecting ideas for tasks related to
OpenTracing, Jaeger or both that would be appropriate for an intern to work on.

Please see the main [program page](https://outreachy.org) for the general information about the program, such
as its purpose, timeline, eligibility requirements, and how to apply.

## What is OpenTracing

OpenTracing is a vendor-neutral open standard for distributed tracing. For the motivation behind OpenTracing,
we recommend watching the presentations available at the page [Talks and Videos](/talks-and-videos).

## What is Jaeger

Jaeger is a concrete set of tracers and a trace storage backend, for usage on applications and microservices
instrumented with OpenTracing. Its [GitHub main readme](https://github.com/jaegertracing/jaeger) is a good
starting point to understand what is Jaeger and how to start using it.

## Schedule
- October 23: - application deadline
- November 9: - selection decisions are made
- December 5 - March 5: - internship

## Coordination

* [Juraci Paixão Kröhling](https://github.com/jpkrohling)
* [Gary Brown](https://github.com/objectiser)

The coordinators can be contacted at any time. The easiest way is to send a message to the mailing list of either
OpenTracing or Jaeger, as both coordinators are present on both mailing lists:

* [OpenTracing Mailing List](https://groups.google.com/forum/#!forum/opentracing)
* [Jaeger Mailing List](https://groups.google.com/forum/#!forum/jaeger-tracing)

Another option is to use Gitter, which is the chat platform used by both the OpenTracing and Jaeger projects:

* [OpenTracing Gitter Channel](http://gitter.im/opentracing/public)
* [Jaeger Gitter Channel](https://gitter.im/jaegertracing/Lobby)

## Mentors

* [Gary Brown](https://github.com/objectiser)
* [Pavol Loffay](https://github.com/pavolloffay)

Similar to contacting the coordinators, the mentors can be contacted at any time either by sending messages to
the mailing lists or Gitter channels.

Interested in becoming a mentor? Contact one of the coordinators!

## Available tasks

### Instrumentation for mobile applications

Mentor: Gary Brown

* Collect ideas on what's possible and what's desirable for mobile applications
* Decide and experiment with different options for an optimized mobile experience, like, which sampling strategies
make more sense
* Create the missing pieces, like OpenTracing framework integration for some Android component, or a specific Jaeger
tracer for mobile usage
* Documentation + examples
* The end result would be: a trace starts when a user opens the app on the phone and backend microservices are called

Desired skills: Java

Optional skills: Building android applications

### Split the Jaeger JavaScript OT library: NodeJS and Browser

Mentor: Pavol Loffay

* HttpSender which works in a web browser
* Intercept web browser events (maybe can be done as OpenTracing instrumentation)

Desired skills: Javascript

### Document the feasibility or infeasibility of candidate format standards for trace/span data

Mentor: Gary Brown

The OpenTracing standard provides a programmatic API to enable applications to report tracing data in a vendor
neutral way. Applications bind to tracing system specific tracers which report the tracing data to their own
backend system in a vendor specific format.

In some situations it would also be desirable to have a vendor neutral tracer bound in the application, reporting
the tracing data in a standard format, which can then be consumed by different tracing systems.

This project will be to conduct a survey of existing potential standard formats and document their suitability
to represent the information captured via the OpenTracing API. The project will also include the development of
a tracer (in any OpenTracing API supported language) to report the standard format, and a backend adapter
to convert it for storage in Jaeger (written as a gateway in language of choice - although Go preferred).

Desired skills: Any programming language with an OpenTracing API

Optional skills: Go preferred for backend adapter, although will initially be implemented as separate gateway so other
languages could be used.

### OpenTracing MockTracer JUnit rule.

Mentor: Pavol Loffay

* Clear reported spans between tests. Automatically assert on errors.

Desired skills: Java

### Move community Jaeger tracers to the jaegertracing organization.

Mentor: Gary Brown

This task include writing integration tests, missing reporters. Candidates include:

* [Ruby](https://github.com/salemove/jaeger-client-ruby)
* [PHP](https://github.com/jukylin/jaeger-php)

Desired skills: Proficiency in the relevant language

### Create OpenTracing API for language not currently supported

Mentor: Pavol Loffay

* For instance, for missing Android parts.

Desired skills: Proficiency in the chosen language

### Write Jaeger tracer implementation for any OpenTracing API.

Mentor: Gary Brown

* C#
* Kotlin for Android

Desired skills: Proficiency in the chosen language


### Conformance Test Suite for OpenTracing API

Mentor: Pavol Loffay

This project will provide a Conformance Test Suite for the OpenTracing API. This will involve:

* Defining the conformance tests to be implemented
* For one or more languages, implementing the tests
* Demonstrate use of the test suite against multiple tracers

Desired skills: Proficiency in the chosen language(s)


Additionally to the tasks above, we recommend looking at the following issue trackers. You might want to pick
an easy one before applying, to get a better sense of what the projects are about.

* [OpenTracing issue tracker](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Aissue+org%3Aopentracing)
* [Jaeger issue tracker](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Aissue+org%3Ajaegertracing)

Do you have an idea for a task that is suitable for this program? Contact the mentors or coordinators! Or
even better, volunteer for mentoring an intern during the work on your idea!

## Code of Conduct

Both OpenTracing and Jaeger are part of the Cloud Native Computing Foundation (CNCF) and have adopted its
[Code of Conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md).

{% include cncf-foundation.html %}

