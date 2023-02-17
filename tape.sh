#!/bin/bash
function inf { 1>&2 echo -e "\x1B[1;32mINF\x1B[0m: $*"; }
function wrn { 1>&2 echo -e "\x1B[1;93mWRN\x1B[0m: $*"; }
function err { 1>&2 echo -e "\x1B[1;31mERR\x1B[0m: $*"; }
if test -d "$1"; then
	err "tape: Passed directory, $1"
	return 1
elif test -z "$*"; then
	err "No files passed."
	exit 1
fi
case $1 in
	_INFILE) err "Passed raw macro."; exit 1;;
	*.txti) redcloth "$1" ;;
	*.org) org-ruby --translate html "$1" ;;
	*.md) comrak --gfm "$1" ;;
	*.html) cat $1 ;;
	*.s[ac]ss) err "Told to render $1, shouldn't happen"; exit 1 ;;
	*.sh) (inf "Running shellscript $1, I hope you know what you're doing..."; source $1 );;
	*) pandoc --columns 168 -t html "$1" || echo "Skipping $i, unknown format" ;;
esac

