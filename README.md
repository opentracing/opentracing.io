[![Build Status](https://api.travis-ci.org/opentracing/opentracing.io.svg?branch=master)](https://travis-ci.org/opentracing/opentracing.io)
[![Join gitter channel](https://badges.gitter.im/opentracing/opentracing.io.svg)](https://gitter.im/opentracing/public)

# ATTENTION: New website coming

A new version of the website, based on hugo, is being developed on th `v2.0` branch:
https://github.com/opentracing/opentracing.io/tree/v2.0

Issues and PRs labeled `v2.0` are related to the new website.

There will be a documentation hackation on **Wednesday, June 13th**. Check out the announcement for details and signup instructions:
https://medium.com/opentracing/opentracing-docuthon-july-13th-f06aab7955fe

# opentracing.io

This repository contains the source code for http://opentracing.io website.

## Contributing

Contributions are always welcome, no matter how large or small. Before contributing,
please read the [code of conduct](code-of-conduct.md).

By contributing to opentracing.io, you agree that your contributions will be licensed
under its [Apache 2.0 License](LICENSE.md).


## Updating the Docs
If you'd like to work on the website locally, first install Hugo and a fork this repository:
* Install Hugo: https://gohugo.io/getting-started/installing/#quick-install
* Fork this repository on GitHub: https://help.github.com/articles/fork-a-repo/

Once `hugo` is installed, you can build the website. First, open up a terminal, navigate to the directory you would like to work in, and clone your fork of this repository. 

```
git clone https://github.com/YOUR_USERNAME/opentracing.io.git
cd opentracing.io
```

Then checkout the `v2.0` branch and build the website using `make`:

```
git checkout v2.0
make
```

One the site is setup, you can start the site locally in development mode:

```
make serve
```

Navigate to http://localhost:1313/ to see the site. Any content changes you make will automatically appear.

Thist's it! Most articles can be found in the `/content` directory, and are written in Markdown. For basic changes, use the following flow:
* edit the markdown files directly 
* commit and push to your fork
* make a pull request

For larger structral changes, please see the [Hugo Documentation](https://gohugo.io/documentation/).
