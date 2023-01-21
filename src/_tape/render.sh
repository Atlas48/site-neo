#!/bin/bash
# render.sh: part of the tape-and-string framework.
cd ..
declare -A title=([not_found]="404 - Page Not Found" [index]="Atlas48's Archives")
for i in *.txti; do
  flatiron < $i | m4 -DTITLE=${title[${i##.html}]} main.html.m4 | sed '/^$/d' > ../${i/txti/html}
done
