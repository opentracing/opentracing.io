---
title: Register your Project
filename: register-your-project
weight: 4
---

# OpenTracing Contributions

OpenTracing-Contrib contains several OpenTracing instrumentation projects developed by contributors. Repositories under [github.com/opentracing-contrib](https://github.com/opentracing-contrib) pertain to specific open-source software packages and projects. Each may have its own owners and internal policies regarding PRs, review requirements, and committer management.

## How to contribute?

You can contribute by either instrumenting your own project with OpenTracing or contributing to the existing projects in the repository. You can learn more about OpenTracing contributions via the [OpenTracing Registry](/registry).

## How can I add my project to the registry?

Adding a project is as simple as making a Pull Request to the OpenTracing website. Any sort of instrumentation, tracer, tracer client library, or other library/application that could be useful is welcome.

First, create a markdown file in the following format -

```
---
title: My Cool Project
registryType: <instrumentation/tracer>
tags:
    - project language
    - other useful info
    - maybe the framework it instruments
    - or the platform it extends
repo: <repository url>
license: <license name; MIT, Apache, etc.>
description: A friendly description for what my project does.
authors: Tracey McTracerson <tracey@trace.all.the.things>
otVersion: latest (or the specific version of OpenTracing supported)
---
```

Once you've done that, create a new PR on the [opentracing.io](https://github.com/opentracing/opentracing.io) repository against the `master` branch. A maintainer will merge your PR at their earliest opportunity and your contribution will be listed in the registry.

## New contributions

OpenTracing needs your help to proliferate. We’ve already had contributors instrument OSS projects, build tracing systems, and work on the API. If you are interested in getting involved, please drop us a note at [the mailing list](https://groups.google.com/forum/#!forum/opentracing) or say hello on [Gitter](https://gitter.im/opentracing/public) and we will work with you to come up with a useful proposal.

### Starting guides
We have prepared for you step by step guides which should help you to start contributing:
 * [java](/guides/java/contributions.md)

## Existing contributions

Many (but not all) contributed OpenTracing instrumentation can be found under the [the OpenTracing-contrib github organization](https://github.com/opentracing-contrib).

Other contributions are included directly/implicitly in the codebase being instrumented, or sometimes in a contrib or ecosystem for said instrumented project.

# Badges

Once you add OpenTracing support for an open-source project, please include an appropriate OpenTracing badge in said project's README.md, website, or similar.

You may either use...

Badge Flavor | Markdown Snippet | Demo
---------- | ---------------- | ------------
Generic | `[![OpenTracing Badge](https://img.shields.io/badge/OpenTracing-enabled-blue.svg)](http://opentracing.io)` | [![OpenTracing Badge](https://img.shields.io/badge/OpenTracing-enabled-blue.svg)](http://opentracing.io)
OT v1.0 | `[![OpenTracing-1.0 Badge](https://img.shields.io/badge/OpenTracing--1.0-enabled-blue.svg)](http://opentracing.io)` | [![OpenTracing-1.0 Badge](https://img.shields.io/badge/OpenTracing--1.0-enabled-blue.svg)](http://opentracing.io)

# Conference Speaking Opportunities

We like to spread the word about OpenTracing at conferences. We're always excited to collaborate with anyone who'd like to help out. If that sounds like you, please drop us a note at [hello@opentracing.com](mailto:hello@opentracing.com). Specifically we are looking for:

1. Co-presenting opportunities around OpenTracing, including workshops like the ones we've run at Kubecon/OSCON/etc
2. Advice if you have spoken at these events or are involved with the committee
3. Suggestions for any other events we should apply to speak at:

We are particularly interested in the following events:

- OSCON
- Monitorama USA
- Signal
- Strange Loop
- Surge
- GitHub Universe
- Go To
- Velocity
- SREcon
- DockerCon
- CoreOS Fest
- Fluent
- Gluecon
- Mesoscon
- PyCon
- Kubecon / CloudNativeCon
- Developer Week
- Cloud Foundry Summit

## License

[Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0).
