#!/usr/bin/env bash

shopt -s extglob

OUTPUT_DIR=${1:-public}
export CI_PROJECT_URL=${CI_PROJECT_URL:-https://gitlab.com/nghinhut/docs}

## Pre-build
#./scripts/plantuml-header-patcher.sh

### Prepare public/
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"
cp -r !(public|*.zip|posts|assets|scripts|web|protos|config.yaml) "$OUTPUT_DIR"

## Build
PLANTUML=scripts/plantuml.1.2019.11.jar
SOURCES_FILES=$(find "$OUTPUT_DIR" -iname '*.puml' | grep -v static)
for file in ${SOURCES_FILES}; do
    printf "Build %s... " "$file"
    java -DPLANTUML_LIMIT_SIZE=8192 -jar $PLANTUML -charset UTF-8 -progress "$file" -tsvg
    java -DPLANTUML_LIMIT_SIZE=8192 -jar $PLANTUML -charset UTF-8 -progress "$file"
    printf " DONE!\n"
done
