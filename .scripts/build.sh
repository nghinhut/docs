shopt -s extglob

./.scripts/prebuild.sh

rm -rf dist/
mkdir -p dist/
cp -r !(dist|*.zip) dist
./.scripts/plantuml-build.sh

rm -f artifacts.zip
cd dist/ && zip -r ../artifacts.zip ./*
