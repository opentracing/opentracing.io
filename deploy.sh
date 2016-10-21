#!/bin/bash

# config
set -o errexit
git config --global user.email "deploy-bot@opentracing.io"
git config --global user.name "Travis Deploy Bot"

# cleanup
rm -rf _site

# build
npm run production

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "master" ]; then
  echo "Skipping deploy; just doing a build."
  exit 0
fi

# deploy
cd _site
git init
git add --all
git commit -m "Deploy to Github Pages"
git push --force "https://${ACCESS_TOKEN}@github.com/${GITHUB_REPO}"  master:gh-pages > /dev/null 2>&1