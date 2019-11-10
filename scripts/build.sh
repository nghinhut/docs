shopt -s extglob

./scripts/prebuild.sh


rm -rf dist/
mkdir -p dist/
cp -r !(dist|*.zip|posts|assets|scripts|tools) dist
./scripts/plantuml-build.sh
rm -f artifacts.zip
cd dist/ && zip -r ../artifacts.zip ./* && cd - || exit

HUGO=$PWD/scripts/hugo_0.59.0
rm -rf ./public
cd ./tools/hugo && $HUGO && cd - || exit
cp -rT dist/ tools/hugo/public/
cp -R assets/ tools/hugo/public/
mv tools/hugo/public public
