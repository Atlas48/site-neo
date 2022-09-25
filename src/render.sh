#!/bin/bash
declare -A title=([not_found]="404 - Page Not Found" [index]="Atlas48's Archives")
for i in *.txti; do
  flatiron <$i> tmp.html
  m4 -DTITLE=${title[${i##.html}]} template.html.m4 > ../${i/txti/html}
  rm tmp.html
done
