shopt -s extglob

./scripts/prebuild.sh


rm -rf dist/
mkdir -p dist/
cp -r !(dist|*.zip|posts|assets|scripts|tools) dist
./scripts/plantuml-build.sh

# Create artifacts.zip file contains all compiled images
#rm -f artifacts.zip
#cd dist/ && zip -r ../artifacts.zip ./* && cd - || exit

HUGO=$PWD/scripts/hugo_0.59.0
rm -rf ./public
$HUGO
cp -rT dist/ ./public/
cp -R assets/ ./public/
