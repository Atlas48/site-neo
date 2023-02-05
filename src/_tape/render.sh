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
	*) pandoc --cols 168 -t html $i || echo "Skipping $i, unknown format" ;;
  esac
}
function yn {
  while true; do
	read -p "$* [y/n]:" yn
	case $yn in
	  [Yy]*) return 0;;
	  [Nn]*)
		echo "Aborted."
		return 1;;
	  *) echo "Please answer Yes or No.";;
	esac
  done
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
	if ! grep -q '.s[ac]ss' "$i"; then
	  sass=+($i)
	  continue
	fi
	tape $i | sed 's/^\s\{1,4\}//' | m4 -DTITLE="$(${prog[title]} $i)" -DLIB=${prog[lib]} ${prog[m4]} > ../${i%.*}.html
  else
	echo "Skipping $i, unknown file type"
  fi
done

if ! ( test -z ${css[@]} ) && yn "Run rcss.sh?"; then
  _tape/rcss.sh ${css[@]}
fi
