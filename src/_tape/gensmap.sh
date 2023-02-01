function r {echo $@ >> sitemap.xml;}
pushd ../..
sed -i d sitemap.xml
r '<?xml version="1.0" encoding="UTF-8"?>'
w '<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
for i in `find *`; do
w "<url>"
w "<loc>https://atlas48.neocities.org/$i</loc>"
w "<lastmod>$(date +"%Y-%M-%d" -r $i)</lastmod>"
r "</url>"
done
r "</urlset>"
