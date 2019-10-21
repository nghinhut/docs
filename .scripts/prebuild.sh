
FILES=$(find -type f -name "*.puml")
HEADER_START="'===== AUTO GENERATE HEADER START ====="
HEADER_END="'===== AUTO GENERATE HEADER END ====="

appendHeaderToFile() {
  file=$1
  generatedHeaderFound=false

  generatedHeaderFound=$(grep "$HEADER_START" $file)

  if [[ -z $generatedHeaderFound ]]; then
    echo "header not found"
    sed -i "s/@startuml/@startuml\n$HEADER_START\n$HEADER_END\n/g" $file
  fi

  HEADER_CONTENT="'header content"
#  sed -e '1h;2,$H;$!d;g' -e "s/$HEADER_START.*$HEADER_END/$HEADER_START\n$HEADER_CONTENT\n$HEADER_END/g"
  sed "/^$HEADER_START$/{$!{N;s/^$HEADER_START\n.*$HEADER_END\$/$HEADER_START\n$HEADER_CONTENT\n$HEADER_END/;ty;P;D;:y}}"
}

for file in $FILES; do
  printf "Processing file %s... " $file
  appendHeaderToFile $file
  printf "done!\n"
done

