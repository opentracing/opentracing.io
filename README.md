This repository contains the source code for http://opentracing.github.io website, generated with [Jekyll](http://jekyllrb.com/).

## Making changes

Create a branch, test the change locally, then create a pull request.

## Testing localling with Jekyll

See https://help.github.com/articles/using-jekyll-with-pages/

or, as a crash course:

* make sure Ruby version 2.0.0 or greater is installed
* install Bundler: `sudo gem install bundler`
* clone the repository and `cd` to it
* install github-pages: `sudo bundle install`
* run the webserver: `bundle exec jekyll serve` 
* check results: `open http://localhost:4000`

Tips:
* Jekyll will regenerate the site as you update the files, unless you edit `_config.yml`, which requires a restart of `jekyll serve`
