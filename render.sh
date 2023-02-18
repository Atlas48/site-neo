#!/bin/bash
# render.sh: part of the tape-and-string framework.
# v3.4-p4
#B: Load
enable -f /usr/lib/bash/csv csv
declare -A title
#E: Load
#B: Definition
function inf { 1>&2 echo -e "\x1B[1;32mINF\x1B[0m: $*"; }
function wrn { 1>&2 echo -e "\x1B[1;93mWRN\x1B[0m: $*"; }
function err { 1>&2 echo -e "\x1B[1;31mERR\x1B[0m: $*"; }
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
	load_title
	if ! test -d out; then
		err "Cannot render, directory 'out' does not exist, run ./render.sh dir"
		return 1
	fi
	local i o doc
	doc=(`./pfiles.rb doc`)
	inf "Rendering document files..."
	for i in ${doc[@]}; do
		o="${i/in/out}"
		echo "'$i' -> '$o'"
		if test -z "${title[$i]}"; then
			m4 -D_INFILE="$i" -DCSSI=$(awk -f awk/getsd.awk <<< "$i") m4/main.html.m4 > ${o%.*}.html
		else
			m4 -D_INFILE="$i" -DCSSI=$(awk -f awk/getsd.awk <<< "$i") -DTITLE="${title[$i]}" m4/main.html.m4 > ${o%.*}.html
		fi
	done
}
function sass {
	if ! test -d out; then
		err "Cannot render, directory 'out' does not exist, run ./render.sh dir"
		return 1
	fi
	local i o sass
	sass=(`./pfiles.rb sass`)
	inf "Rendering sass files..."
	if [ ${#sass[@]} -eq 0 ]; then
		inf "No .sass files detected, skipping"
		return 0
	else
		for i in ${sass[@]}; do
			o="${i/in/out}"
			o="${o/.s[ac]/.c}"
			echo "'$i' -> '$o'"
			sassc -t expanded -a $i | sed '/^$/d' > $o
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
	load_title
	dirs
	docs
	sass
	other
}
function info {
	load_title
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
function load_title {
	local ii
	while read -r ii; do
		csv -a i "$ii"
		title[in/${i[0]}]=${i[1]}
	done < dat/title.csv
}
#E: Definition
#B: Logic
#B: Logic/LoadDefs
#B: Logic/LoadDefs/ignore
if test -f ignore.txt; then
	while read -r i; do
		ignore+=(in/$i)
	done < dat/ignore.txt
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
	docs) docs;;
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
