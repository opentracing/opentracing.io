---
title: May 2018 - Aug. 2018
---

# Outreachy

The OpenTracing and Jaeger projects are happy to announce our participation in the Outreachy program, running
from May 2018 to August 2018. 

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
- mid-February to end of March: - application deadline
- mid April: - selection decisions are made
- end of May to end of August: - internship

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

* [Julie Stickler](https://github.com/JStickler)

Similar to contacting the coordinators, the mentors can be contacted at any time either by sending messages to
the mailing lists or Gitter channels.

Interested in becoming a mentor? Contact one of the coordinators!

Do you have an idea for a task that is suitable for this program? Contact the mentors or coordinators! Or
even better, volunteer for mentoring an intern to work on your idea!

## Contribute

As part of the application process, the Outreachy program recommends that candidates make 
[small contributions](https://www.outreachy.org/apply/make-contributions/) to the project they intend to apply for.

For this round, we are looking for an intern to help us on the documentation side of the projects. As such, we would
like to ask candidates to finish the task "Set up Documentation Environment" and one of the other two tasks.

The tasks are relevant for any repository found in any of the following organizations:

* [OpenTracing](https://github.com/opentracing)
* [Jaeger Tracing](https://github.com/jaegertracing)
* [OpenTracing Contributions](https://github.com/opentracing-contrib)

### Set up Documentation Environment

Set up your development environment for the OpenTracing docs repo and verify that you understand the workflow by submitting a small change.
See [CONTRIBUTING.md](https://github.com/opentracing/opentracing.io/blob/master/CONTRIBUTING.md)

* Do some research to learn about [Jekyll](https://jekyllrb.com/)
* Install Node.js
* Install NVM
* Install NPM
* Install Jekyll
* Fork the Repo [opentracing/opentracing.io](https://github.com/opentracing/opentracing.io)
* Clone the Repo
* Explore the [project structure](https://github.com/opentracing/opentracing.io/blob/master/CONTRIBUTING.md#project-structure)
* Run opentracing.io locally
* Create a branch
* Make a small change to a document/page (find a typo, spelling, or grammar error)
* Write a good commit message
* Push it to your fork.
* Submit a Pull Request with your change (PR)

Set up your development environment for JaegerTracing docs repo and verify that you understand the workflow by submitting a small change.
See [README.md](https://github.com/jaegertracing/documentation/blob/master/README.md)

* Install [virtualenv](https://virtualenv.pypa.io/en/stable/installation/)
* Install [MkDocs](http://www.mkdocs.org/#installation)
* Fork the Repo
* Clone the Repo
* Explore the project structure 
* Create a branch
* Make a small change to a document/page (find a typo, spelling, or grammar error)
* Write a good commit message
* Push it to your fork.
* Submit a Pull Request with your change (PR)

### Find a repo whose README file does not list the open source license

* Locate the license file in the repo
* Add the license information to the README and submit a Pull Request (PR)
* If there is no license file in the repo, create an issue.

### Find a repo that does not have a README file

Write a README file that includes at least the following information:

1. The name of the repository.
1. A short description of what is in the repository
1. The license that the covers the contents of the repository.

## Internship tasks

Mentor: Julie Stickler

All of the following tasks are in the context of the internship. While all items will be used during the evaluation, 
the first two tasks are "mandatory" to consider the internship "successful".

### Contributor Docs

Document any additional steps that you needed to perform in order to get your system 
configured that were not covered in the instructions linked from these pages.
(That is, if there is a link on the page, there is no need to duplicate the instructions from the link, as long as they work.)

* [opentracing/opentracing.io/CONTRIBUTING.md](https://github.com/opentracing/opentracing.io/blob/master/CONTRIBUTING.md)
* [jaegertracing/documentation/README.md](https://github.com/jaegertracing/documentation/blob/master/README.md)

Developers tend to work in a Linux environment. Technical Writers are sometimes more familiar
with other operating systems. If you are new to Linux or are working on a Mac or Windows environment, 
your contribution might help other writers who want to contribute to an Open Source project.

### Standardize README files

Standardize the README files across the repos.
[Watch](https://pronovix.com/api-docs-london-2017#ben) Ben Hall’s talk about the Art of Documentation and the README

Do some research into Read Me templates:
* [zalando/zalando-howto-open-source/READMEtemplate.md](https://github.com/zalando/zalando-howto-open-source/blob/master/READMEtemplate.md)
* [shaloo/structuredreadme](https://github.com/shaloo/structuredreadme)
* [cfpb/open-source-project-template](https://github.com/cfpb/open-source-project-template)
* [noffle/art-of-readme](https://github.com/noffle/art-of-readme)

1. Create a standardized template 
1. Update all the OpenTracing Repos to use the README template
1. Update all the JaegerTracing Repos to use the README template
1. [Readme files for Docker Hub](https://github.com/jaegertracing/jaeger/issues/188)

### Small Fixes to existing docs

Select a file and fix any spelling errors, grammatical errors, or broken links.  Common errors may include spelling mistakes, 
subject/verb agreement errors, and missing articles (a, an, the).

Be sure to distinguish between actual spelling errors and names of components, other open source projects, or technologies 
(which can often look like misspellings or capitalization errors)

1. [Fix a typo](https://github.com/opentracing/opentracing.io/issues/231)
1. [Make a fix on the web site](https://github.com/opentracing/opentracing.io)
1. [Make a fix in the documentation](https://github.com/opentracing/opentracing.io/tree/master/_docs)

### Testing existing docs

Test the existing docs to see if they can be followed.
Revise to correct errors and add missing information.

Reference: [jaegertracing/jaeger#472](https://github.com/jaegertracing/jaeger/issues/472)

### Docs site needs an FAQ section

Monitor communication channels and issues and add new topics to the [FAQ](https://github.com/opentracing/opentracing.io/issues/134)

### Create a UI page listing known integrations & instrumentation libraries

[opentracing/opentracing.io#192](https://github.com/opentracing/opentracing.io/issues/192)

### Document feature matrix for client libraries

[jaegertracing/jaeger#384](https://github.com/jaegertracing/jaeger/issues/384)

## Previous programs

OpenTracing and Jaeger participated in the following Outreachy programs:

* [December 2017 to March 2018](/outreachy-201702)

## Code of Conduct

Both OpenTracing and Jaeger are part of the Cloud Native Computing Foundation (CNCF) and have adopted its
[Code of Conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md).

{% include cncf-foundation.html %}
