#!/bin/bash
# render.sh: part of the tape-and-string framework.
# v2.1
declare -A prog
prog[m4]=`readlink -f main.html.m4`
prog[lib]=`readlink -f lib.m4`
prog[title]=`readlink -f titlelookup`
function tape {
  case $1 in
	*.txti) redcloth $1 ;;
	*.org) org-ruby --translate html $1 ;;
	*.md) comrak --gfm $1 ;;
	*.html) cat $1 ;;
	*) pandoc --cols 168 -t html $i || echo "Unable to render $i, unknown format" ;;
  esac
}
cd ..
files=(`find -not -path './_*'`)
for i in ${files[@]}; do
  echo $i
  if test -d $i; then
	if test -d ../$i; then
	  mkdir -vp ../$i
	else continue
	fi
  elif test -f $i; then
	tape $i | m4 -DTITLE=`${prog[title]}` -DLIB=${prog[lib]} ${prog[m4]} > ../$i
  else
	echo "Skipping $i, unknown file type"
  fi
done
