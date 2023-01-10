#!/usr/bin/env bash

set -e

npm run generate

cd dist

git init
git add -A
git commit -m 'New Deployment'
git push -f git@github.com:j2sman/latincielo.github.io master:gh-pages

cd -