[![Build Status](https://api.travis-ci.org/opentracing/opentracing.io.svg?branch=master)](https://travis-ci.org/opentracing/opentracing.io)
[![Join gitter channel](https://badges.gitter.im/opentracing/opentracing.io.svg)](https://gitter.im/opentracing/public)

# opentracing.io

This repository contains the source code for http://opentracing.io website.

## Contributing

Contributions are always welcome, no matter how large or small. Before contributing,
please read the [code of conduct](code-of-conduct.md).

By contributing to opentracing.io, you agree that your contributions will be licensed
under its [Apache 2.0 License](LICENSE.md).

## Local Development
If youu'd like to work on the website locally, first install the site dependencies:
* Install NPM: https://nodejs.org/en/ (NPM comes with NodeJS)
* Install Hugo: https://gohugo.io/getting-started/installing/#quick-install

Once the above dependencies are installed, you can install the website. First, open up a terminal, navigate to the directory you would like to work in, and clone your fork of this repository. Then checkout the `v2.0` branch and install the website with the following commands:

```
git checkout v2.0
make
```

To start the site locally in development mode, run the following:

```
make dev
```

Navigate to http://localhost:1313/ to see the site. Any content changes you make will automatically appear.

Most articles can be found in the `/content` directory, and are written in Markdown. For basic changes, simply fork the site, edit the markdown files directly, and make a pull request. For larger structral changes, please see the [Hugo Documentation](https://gohugo.io/documentation/).
