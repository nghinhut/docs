
FILES=$(find -type f -name "*.puml")
HEADER_START="=====AUTO GENERATE HEADER START====="
HEADER_END="=====AUTO GENERATE HEADER END====="

appendHeaderToFile() {
  file=$1
  generatedHeaderFound=false

  generatedHeaderFound=$(grep "$HEADER_START" $file)

  if [[ -z $generatedHeaderFound ]]; then
    echo "header not found"
    sed -i "s/@startuml/@startuml\n$HEADER_START\n$HEADER_END\n/g" $file
  fi


}

for file in $FILES; do
  printf "Processing file %s... " $file
  appendHeaderToFile $file
  printf "done!\n"
done

