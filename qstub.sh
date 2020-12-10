#!/bin/bash

POSITIONAL=()
STUBFILE="$HOME/kdb/qstub.q"

while [[ $# -gt 0 ]]
do
key=$1

case $key in 
     -s | --stubfile)
     STUBFILE="$2"; shift; shift
     ;;
     -f | --file)
     FILE="$2"; shift; shift
     ;;
     -h | --help)
     echo "Usage: qstub [-f filepath] [-s stubfile] [-h]"
     exit 0
     ;; 
     *)
     POSITIONAL+=("$1")
     shift
     ;;
esac
done

set -- "${POSITIONAL[@]}"
echo "File is ${FILE}"
cp $STUBFILE $FILE

