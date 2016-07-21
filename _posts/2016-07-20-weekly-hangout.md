### Attendees 
[@bg451](https://github.com/bg451), [@pritianka](https://github.com/pritianka), [@bensigelman](https://github.com/bensigelman), [@yurishkuro](https://github.com/yurishkuro)

### Notes
* Uber open sourced their Java based tracer that uses OT. It’s called Jaeger. [@yurishkuro](https://github.com/yurishkuro): Jaeger is not ready but it is not super far behind. If someone wanted to use the b3 header, they can. 

* Issues gating OpenTracing 1.0 Spec were discussed.
<br />
* Re: [Not sure which issue this one is -> [Simplify and generalize Span.log API](https://github.com/opentracing/opentracing.github.io/issues/96)?]
<br />
Main meaningful change that’s missing for the Java API. String of text might be better than a constant. It is not as clean from the type safety standpoint, but it makes the code more readable and self-describing. It’s something everyone can understand. But not everyone is in agreement so the plan is - we will resurrect this issue, check what people say for a couple of options. Status quo, single string, double parameter, [yuri’s option]. 

* Re: [Make HTTP transport easy without tightly coupling to OT](https://github.com/opentracing/opentracing.github.io/issues/98) 
<br />
We need to add HTTP support across the board. 

* Re: [introduce a formal SpanContext concept at the OT layer](https://github.com/opentracing/opentracing.github.io/issues/99) 
<br />
Span context mostly done. 

* Re: [RFC: SpanContext should be immutable](https://github.com/opentracing/opentracing.github.io/issues/106)
<br />
Span context immutability - We should make the mutation happen through span, not span context API. Saying you can’t change baggage after start time is a big change. But saying you can do it through the span, it makes sense. It’s confusing to have setter and getter in the same place. The concern of having a setter is basically performance. Hung trial.

* CNCF 
<br />
We are considering joining CNCF. Linux foundation would own the IP and have final say. However, we would not signing up for a big process from a governance standpoint, unlike Apache. They also want Zipkin in the organization. They have $$ to put behind this. 

* [Didn’t catch what the last issue discussed was. [Remove charset restrictions on baggage item keys](https://github.com/opentracing/opentracing.github.io/issues/95)?]
