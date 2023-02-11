#!/bin/bash
# render.sh: part of the tape-and-string framework.
# v3.2-p1
#B: Load
enable -f /usr/lib/bash/csv csv
declare -A title
#E: Load
#B: Definition

function in_arr {
  for i in "${@:2}"; do
    [[ "$i" = "$1" ]] && return 0
  done
  return 1
}
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
  *.s[ac]ss) err "Told to render $1, shouldn't happen"; return 1 ;;
	*) pandoc --columns 168 -t html "$1" || echo "Skipping $i, unknown format" ;;
  esac
}
function dirs {
  if test -d out; then
    wrn "Directory 'out' already exists."
    return 0
  fi
  local i o dir
  dir=(`./pfiles.rb dir`)
  inf "Creating directory structure..."
  echo ${dir[@]}
  for i in ${dir[@]}; do
	o="${i/in/out}"
	mkdir -pv $o
  done
}
function docs {
  if ! test -d out; then
    err "Cannot render, directory 'out' does not exist, run ./render.sh dir"
    return 1
  fi
  local i o doc
  doc=(`./pfiles.rb doc`)
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
  if ! test -d out; then
    err "Cannot render, directory 'out' does not exist, run ./render.sh dir"
    return 1
  fi
  local i o sass scss
  sass=(`./pfiles.rb sass`)
  scss=(`./pfiles.rb scss`)
  inf "Rendering sass files..."
  if [ ${#sass[@]} -eq 0 ]; then
	  inf "No .sass files detected, skipping"
	  unset sass
  else
	  for i in ${sass[@]}; do
	    o="${i/in/out}"
	    o="${o/.sa/.c}"
	    echo "$i => $o"
	    sassc -a $i $o
	  done
  fi
  if [ ${#scss[@]} -eq 0 ]; then
	  inf "No .scss files detected, skipping."
	  unset scss
  else
	for i in ${scss[@]}; do
	  o="${i/in/out}"
	  o="${o/\.s/.}"
	  echo "$i => $o"
	  sassc $i $o
	done
  fi
}
function other {
  if ! test -d out; then
    err "Cannot render, directory 'out' does not exist, run ./render.sh dir"
    return 1
  fi
  inf "Copying other files..."
  cp -rv 'in'/* out/
}
function all {
  dirs
  docs
  sass
  other
}
function info {
  local i
  echo "* \$ignore"
  if [ ${#ignore[@]} -eq 0 ]; then
    echo null
  else
    for i in ${ignore[@]}; do
      echo "- $i"
    done
  fi
  echo "* \$titles"
  for i in ${!title[@]}; do
    echo " - $i :: ${title[$i]}"
  done
}
#E: Definition
#B: Logic
#B: Logic/LoadDefs
#B: Logic/LoadDefs/title
while read -r ii; do
  csv -a i "$ii"
  title[in/${i[0]}]=${i[1]}
done < title.csv
#E: Logic/LoadDefs/title
unset ii
#B: Logic/LoadDefs/ignore
if test -f ignore.txt; then
  while read -r i; do
    ignore+=(in/$i)
  done < ignore.txt
fi
#E: Logic/LoadDefs/ignore
#E: Logic/LoadDefs
if test -z "$*"; then
  all
  exit $?
fi
case $1 in
dir) dirs;;
doc) docs;;
s[ac]ss) sass;;
other) other;;
rest) other;;
info) info;;
vall) info; all;;
all) all;;
*) all;;
esac
#E: Logic
exit $?
