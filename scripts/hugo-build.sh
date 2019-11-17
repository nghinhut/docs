#!/usr/bin/env bash
## Cleanup all files in public/ but keep some.
shopt -s extglob
mkdir -p public
cd public && rm -vrf !(plantuml|LICENSE|README.md) && cd ..


## Hugo build
HUGO=$PWD/scripts/hugo_0.59.0
$HUGO
cp -R assets/ ./public/
