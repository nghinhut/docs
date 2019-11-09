shopt -s extglob

./.scripts/prebuild.sh


rm -rf dist/
mkdir -p dist/
cp -r !(dist|*.zip|posts|assets) dist
./.scripts/plantuml-build.sh
rm -f artifacts.zip
cd dist/ && zip -r ../artifacts.zip ./* && cd - || exit

HUGO=$PWD/.scripts/hugo_0.59.0
rm -rf ./public
cd ./.hugo && $HUGO && cd - || exit
cp -rT dist/ .hugo/public/
mv .hugo/public public
#cp -rT .hugo/public dist/
#mv dist public
