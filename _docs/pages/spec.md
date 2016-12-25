# Concepts and Terminology

All language-specific OpenTracing APIs share core concepts and terminology. These concepts are so central and important to the project that they have their own repository ([github.com/opentracing/specification](https://github.com/opentracing/specification)) and semver scheme.

This `specification` repository houses two important files:

1. [`specification.md`](https://github.com/opentracing/specification/blob/master/specification.md) is a versioned description of the current pan-language OpenTracing standard
1. [`data_conventions.yaml`](https://github.com/opentracing/specification/blob/master/data_conventions.yaml) is a structured YAML file describing standard Span tags and Span log keys

Both are versioned and the github repository is tagged according to the rules described at [the top of the specification document](https://github.com/opentracing/specification/blob/master/specification.md#versioning-policy).
