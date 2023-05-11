#!/bin/bash
# gensimap.sh: Generate a sitemap for my website.
# v2.0p1
function inf { 1>&2 echo -e "\x1B[1;32mINF\x1B[0m: $*"; }
function err { 1>&2 echo -e "\x1B[1;31mERR\x1B[0m: $*"; }
function r { echo $@ >> out/sitemap.xml; }
inf "Generating Sitemap..."
if ! test -d out; then
	err "Directory 'out' not created, cannot write sitemap."
	exit 1
fi
if test -f out/sitemap.xml; then
	inf "Overwriting current sitemap..."
	sed -i d sitemap.xml
fi
r '<?xml version="1.0" encoding="UTF-8"?>'
r '<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
for i in `find in -type f -name '*.html'`; do
r "<url>"
r "<loc>https://atlas48.neocities.org/$i</loc>"
r "<lastmod>$(date +"%Y-%M-%d" -r $i)</lastmod>"
r "</url>"
done
r "</urlset>"
