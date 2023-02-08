function r { echo $@ >> out/sitemap.xml; }
test -d out/sitemap.xml && sed -i d sitemap.xml
r '<?xml version="1.0" encoding="UTF-8"?>'
r '<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
for i in `find in -type f -name '*.html'`; do
r "<url>"
r "<loc>https://atlas48.neocities.org/$i</loc>"
r "<lastmod>$(date +"%Y-%M-%d" -r $i)</lastmod>"
r "</url>"
done
r "</urlset>"
