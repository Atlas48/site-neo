#!/bin/bash
# render.sh: part of the tape-and-string framework.
# v3.1
enable -f /usr/lib/bash/csv csv
declare -A title
while read -r ii; do
  csv -a i "$ii"
  title[in/${i[0]}]=${i[1]}
done <title.csv
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
doc=(`find in -type f -name '*.txti' -o -name '*.org' -o -name '*.md'`)
sass=(`find in -type f -name '*.sass'`)
scss=(`find in -type f -name '*.scss'`)
rest=(`find in -type f ! \( -name '*.org' -o -name '*.txti' -o -name '*.md' -o -name .hg \)`)
dir=(`find in -type d`)

function dirs {
inf "Creating directory structure..."
echo ${dir[@]}
for i in ${dir[@]}; do
  o="${i/in/out}"
  mkdir -pv $o
done
}
function docs {
inf "Rendering document files..."
for i in ${doc[@]}; do
  o="${i/in/out}"
  echo "$i => $o"
  if test -z "${title[$i]}"; then
	tape $i | m4 m4/main.html.m4 > ${o%.*}.html
  else
	tape $i | m4 -DTITLE="${title[$i]}" m4/main.html.m4 > ${o%.*}.html
  fi
done
}
function sass {
inf "Rendering sass files..."
if test -z "${sass[@]}"; then
  inf "No .sass files detected, skipping"
  unset sass
else
  for i in ${sass[@]}; do
	o="${i/in/out}"
	echo "$i => $o"
	sassc -a $i ${o/sa/c}
  done
fi
if test -z "${scss[@]}"; then
  inf "No .scss files detected, skipping."
  unset scss
else
  for i in ${scss[@]}; do
	o="${i/in/out}"
	echo "$i => $o"
	sassc $i ${o#s}
  done
fi
}
function other {
inf "Copying other files..."
cp -rv 'in'/* out/
}
function all {
dirs
docs
sass
other
}
if test -z "$*"; then
  all
  exit 0
fi
case $1 in
  dir) dirs;;
  doc) docs;;
  s[ac]ss) sass;;
  other) other;;
  all) all;;
  *) all;;
esac
