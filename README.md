opentracing.io
====

> repo for the opentracing.io + documentation

[![Build Status](https://api.travis-ci.org/opentracing/opentracing.io.svg?branch=master)](https://travis-ci.org/opentracing/opentracing.io)
[![Join gitter channel](https://badges.gitter.im/opentracing/opentracing.io.svg)](https://gitter.im/opentracing/public)

This repository contains the source code for http://opentracing.io website, generated with Jekyll + Node.js + Gitbook.

We build this  static page using Travis when master changes. You can see the latest build [here](https://api.travis-ci.org/opentracing/opentracing.io)

## Prerequisites

You need to have Node.js, NPM and Jekyll installed on your computer.

```
node --version
> v4.6.0

npm --version
> 2.15.9

jekyll --version
> jekyll 3.1.2
```

## Running Opentracing.io locally

### Install dependencies
```
nvm use
npm install
```

### Run locally
```
npm run dev
open http://localhost:4000
```

## Project structure

### Folders

#### _data
collections of data that is then used in to render liquid templates

#### _docs
The gitbook documentation that is then built into /documentation on build

#### _includes, _layouts
jekyll folders containing html templates and layouts

#### _sass
Contains the scss that is then preprocessed into /css on build

#### _site
Jekyll temp folder when running `jekyll serve`. You can ignore this.

#### fonts, img
static content

#### css, documentation
post-build static assets. don't edit these.

