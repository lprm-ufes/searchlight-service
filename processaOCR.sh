#!/bin/bash
ext=${1: -3};
# baixa imagem que sera feita o ocr
wget $1 -O /tmp/ocr.$ext -o /tmp/ocr.log
#processa o ocr
coffee node_modules/fv/bin/cli.coffee --schema=/tmp/ocr.json /tmp/ocr.$ext
