shopt -s extglob

rm -rf dist/
mkdir -p dist/
cp -r !(dist) dist
