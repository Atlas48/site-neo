#!/bin/bash
# render.sh: part of the tape-and-string framework.
# v3.0
. titles.sh
function inf { echo -e "\x1B[1;32mINF\x1B[0m: $*"; }
function wrn { echo -e "\x1B[1;93mWRN\x1B[0m: $*"; }
function err { echo -e "\x1B[1;31mERR\x1B[0m: $*"; }
function tape {
  if test -d "$1"; then
	err "tape: Passed directory, $1"
	return 1
  fi
  case $1 in
	*.txti) redcloth "$1" ;;
	*.org) org-ruby --translate html "$1" ;;
	*.md) comrak --gfm "$1" ;;
	*.html) cat $1 ;;
	*) pandoc --columns 168 -t html "$1" || echo "Skipping $i, unknown format" ;;
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
doc=(`find . -wholename './.hg' -prune , -type f -name '*.txti' -o -name '*.org' -o -name '*.md'`)
sass=(`find . -wholename './.hg' -prune , -type f -name '*.sass'`)
scss=(`find . -wholename './.hg' -prune , -type f -name '*.scss'`)
rest=(`find . -wholename './.hg' -prune , -type f ! \( -name '*.org' -o -name '*.txti' -o -name '*.md' -o -name .hg \)`)
dir=(`find . -wholename './.hg' -prune , -type d -not -name .hg`)

inf "Creating directory structure..."
for i in ${dir[@]}; do
  echo $i
  mkdir -p out/$i
done
inf "Rendering document files..."
for i in ${doc[@]}; do
  echo $i
  tape $i | m4 -DTITLE="${title[$i]}" main.html.m4 > out/${i%.*}.html
done
inf "Rendering sass files..."
if test -z "${sass[@]}"; then
  inf "No .sass files detected, skipping"
  unset sass
else
  for i in ${sass[@]}; do
	echo $i
	sassc -a $i out/$i
  done
fi
if test -z "${scss[@]}"; then
  inf "No .scss files detected, skipping."
  unset scss
else
  for i in ${scss[@]}; do
	echo $i
	sassc $i out/$i
  done
fi
inf "Copying other files..."
# Probably a more efficient way to do this.
for i in ${rest[@]}; do
  cp -v $i out/$i
done
