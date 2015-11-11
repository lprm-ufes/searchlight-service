#!/bin/bash
ext=${1: -3};
# baixa imagem que sera feita o ocr
#wget $1 -O /tmp/$2.$ext -o /tmp/$2.log
#processa o ocr
coffee node_modules/fv/bin/cli.coffee --lang=por --schema=/tmp/$2.json $1
#rm /tmp/$2.json
#rm /tmp/$2.$ext
