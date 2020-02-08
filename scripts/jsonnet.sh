#!/usr/bin/env bash
[[ -z $CI ]] && sudo chown 1001:1001 -R .

docker run --rm -it -v `pwd`:/defs -w /defs bitnami/jsonnet:latest $@

[[ -z $CI ]] && sudo chown -R $USER .
