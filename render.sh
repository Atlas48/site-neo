#!/bin/bash
# render.sh: part of the tape-and-string framework.
#V:3.6-p1
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
		o="${o%.*}.html"
		echo "'$i' -> '$o'"
		if test -z "${title[$i]}"; then
			m4 -D_INFILE="$i" -DCSSI=$(awk -f awk/getsd.awk <<< "$i") m4/main.html.m4 > $o
		else
			m4 -D_INFILE="$i" -DCSSI=$(awk -f awk/getsd.awk <<< "$i") -DTITLE="${title[$i]}" m4/main.html.m4 > $o
		fi
	done
}
function sassfn {
	if ! test -d out; then
		err "Cannot render, directory 'out' does not exist, run ./render.sh dir"
		exit 1
	fi
	inf "Rendering sass files..."
	sass --no-source-map in/css:out/css
}
function other {
	local o other=`./pfiles.rb rest`
	for i in $other; do
		o=${i/in/out}
		if test -f $o; then
			inf "Skipping $i, file/hardlink exists..."
			continue
		fi
		ln -v $i $o
	done
}
function all {
	load_title
	dirs
	docs
	sassfn
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
	clean) rm -rf out;;
	dir) dirs;;
	doc) docs;;
	docs) docs;;
	s[ac]ss) sassfn;;
	other) dirs; other;;
	rest) other;;
	info) info;;
	sitemap) ./sitemap.sh;;
	vall) info; all;;
	all) all;;
	*)
		err "Invalid option, $1"
		exit 1
	;;
esac
#E: Logic
exit $?
