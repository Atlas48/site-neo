#!/usr/bin/awk
BEGIN{FS="/";x=2}
/\.\//{x++}
{gsub($0,"./","");print $x;exit}
