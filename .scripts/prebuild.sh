
FILES=$(find -type f -name "*.puml")
BEGIN_HEADER="'-----START auto generated metadata please keep comment here to allow auto update-----"
HEADER_NOTIFY="'-----DON'T EDIT THIS SECTION, INSTEAD RE-RUN prebuild.sh TO UPDATE-----"
END_HEADER="'-----END auto generated metadata please keep comment here to allow auto update-----"

appendHeaderToFile() {
  file=$1
  generatedHeaderFound=false

  generatedHeaderFound=$(grep "$BEGIN_HEADER" $file)

  beginHeaderLineNumber=$(grep -n "$BEGIN_HEADER" "$file" | cut -d: -f1)
  endHeaderLineNumber=$(grep -n "$END_HEADER" "$file" | cut -d: -f1)

  if [[ $beginHeaderLineNumber && $endHeaderLineNumber ]]; then
    # header exists
    sed -i "${beginHeaderLineNumber},${endHeaderLineNumber}d" "$file"
  fi

  if [[ -z $generatedHeaderFound ]]; then
    echo "header not found"
#    sed -i "s/@startuml/@startuml\n$BEGIN_HEADER\n$END_HEADER\n/g" "$file"
  fi

  filepath=$(echo "$file" | cut -d. -f2 | sed -e "s/\//\\\\\//g")
  diagramURL="https\:\/\/gitlab\.com\/nghinhut\/docs\/blob\/$(git rev-parse HEAD)$filepath\.puml"
  previewURL="http\:\/\/www\.plantuml\.com\/plantuml\/proxy?fmt=svg\&src=https\:\/\/gitlab\.com\/nghinhut\/docs\/raw\/$(git rev-parse HEAD)$filepath\.puml"
  HEADER_CONTENT="header \[[mailto:nghinhut@gmail.com @nghinhut]]\nfooter [[$previewURL $diagramURL]]"
#  sed -e '1h;2,$H;$!d;g' -e "s/$BEGIN_HEADER.*$END_HEADER/$BEGIN_HEADER\n$HEADER_CONTENT\n$END_HEADER/g"
#  sed "/^$BEGIN_HEADER$/{$!{N;s/^$BEGIN_HEADER\n.*$END_HEADER\$/$BEGIN_HEADER\n$HEADER_NOTIFY\n$HEADER_CONTENT\n$END_HEADER/;ty;P;D;:y}}"
#  perl -i -p0e "s/$BEGIN_HEADER.*?$END_HEADER/$BEGIN_HEADER\n$HEADER_NOTIFY\n$HEADER_CONTENT\n$END_HEADER/igs" "$file"
  sed -i "s/@startuml/@startuml\n$BEGIN_HEADER\n$HEADER_NOTIFY\n$HEADER_CONTENT\n$END_HEADER/g" "$file"
}

for file in $FILES; do
  printf "Processing file %s... " $file
  appendHeaderToFile $file
  printf "done!\n"
done

