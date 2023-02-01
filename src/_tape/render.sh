#!/bin/bash
# render.sh: part of the tape-and-string framework.
# v2.0
source string.sh
cd ..
files=(`find -not -path './_*'`)
for i in ${files[@]}; do
  if test -d $i; then
	if test -d ../$i; then
	  mkdir -p ../$i
	else continue
	fi
  elif test -f $i; then
	tape $i | m4 -DTITLE=`${prog[title]}` ${prog[m4]} < $i > ../$i
  else
	echo "Skipping $i, unknown file type"
  fi
done
