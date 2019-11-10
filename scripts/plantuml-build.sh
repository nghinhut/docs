#!/usr/bin/env bash

## Configuration
OUTPUT_DIR=${1:-dist}
PLANTUML=scripts/plantuml.1.2019.11.jar
SOURCES_FILES=$(find "$OUTPUT_DIR" -iname '*.puml' | grep -v static)

## Build
for file in ${SOURCES_FILES}; do
    printf "Build %s... " "$file"
    java -DPLANTUML_LIMIT_SIZE=8192 -jar $PLANTUML -charset UTF-8 -progress "$file" -tsvg
    java -DPLANTUML_LIMIT_SIZE=8192 -jar $PLANTUML -charset UTF-8 -progress "$file"
    printf " DONE!\n"
done
