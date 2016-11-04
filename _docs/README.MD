---
layout: page
title: OpenTracing Overview
---
# 为什么需要Tracing？
开发和工程团队因为系统组件水平扩展、开发团队小型化、敏捷开发、CD（持续集成）、解耦等各种需求，正在使用现代的微服务架构替换老旧的单片机系统。
也就是说，当一个生产系统面对真正的高并发，或者解耦成大量微服务时，以前很容易实现的重点任务变得困难了。过程中需要面临一系列问题：用户体验优化、后台真是错误原因分析，分布式系统内各组件的调用情况等。
当代分布式跟踪系统（例如，Zipkin, Dapper, HTrace, X-Trace等）旨在解决这些问题，但是他们使用不兼容的API来实现各自的应用需求。尽管这些分布式追踪系统有着相似的API语法，但各种语言的开发人员依然很难将他们各自的系统（使用不同的语言和技术）和特定的分布式追踪系统进行整合，

# 为什么需要OpenTracing？
OpenTracing通过提供平台无关、厂商无关的API，使得开发人员能够方便的添加（或更换）追踪系统的实现。 OpenTracing提供了用于运营支撑系统的和针对特定平台的辅助程序库。程序库的具体信息请参考详细的规范。

# 什么是一个Trace?

在广义上，一个trace代表了一个事务或者流程在（分布式）系统中的执行过程。在OpenTracing标准中，trace是多个span组成的一个有向无环图（DAG），每一个span代表trace中被命名并计时的连续性的执行片段。

![](images/OTOV_0.png)

分布式追踪中的每个组件都包含自己的一个或者多个span。例如，在一个常规的RPC调用过程中，OpenTracing推荐在RPC的客户端和服务端，至少各有一个span，用于记录RPC调用的客户端和服务端信息。

![](images/OTOV_1.png)

A parent span may explicitly start other spans, either in serial or in parallel. In OpenTracing, it is even possible to model a child span with multiple parents (e.g., a buffer flush may descend from the multiple writes that filled said buffer).

## A Basic Trace

![](images/OTOV_2.png)

Tracing a workflow or transaction through a distributed system often looks something like the above. While this type of visualization can be useful to see how various components fit together, it does not convey any time durations, does not scale well, and is cumbersome when parallelism is involved. Another limitation is that there is no way to easily show latency or other aspects of timing. A more useful way to visualize even a basic trace often looks like this:

![](images/OTOV_3.png)

This type of visualization adds the context of time, the hierarchy of the services involved, and the serial or parallel nature of the process/task execution. This view helps to highlight the system's critical path. By focusing on the critical path, attention can focus on the area of code where the most valuable improvements can be made. For example, you might want to trace the resource allocation spans inside an API request down to the underlying blocking calls.

---
