## This script is for local dev

## Build all *.puml files in public/
./scripts/plantuml-build.sh
./scripts/hugo-build.sh

# Create artifacts.zip file contains all compiled images
#rm -f artifacts.zip
#cd dist/ && zip -r ../artifacts.zip ./* && cd - || exit
