#!/bin/bash

# config
set -o errexit
git config --global user.email "deploy-bot@opentracing.io"
git config --global user.name "Travis Deploy Bot"

# cleanup
rm -rf _site

# build
npm run production

# deploy
cd _site
git init
git add --all
git commit -m "Deploy to Github Pages"
git push --force "https://${ACCESS_TOKEN}@github.com/${GITHUB_REPO}"  master:gh-pages > /dev/null 2>&1