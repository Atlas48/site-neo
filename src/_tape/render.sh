#!/bin/bash
# render.sh: part of the tape-and-string framework.
# v2.0
cd ..
files=(`find -not -path '_*'`)
for i in ${files[@]}; do
  if test -d $i; then
	mkdir -p ../$i
  elif test -f $i; then
	tape $i | m4 -DTITLE=`${prog[title]} $i` .
  else
	echo "Skipping $i, unknown file type"
  fi
done
