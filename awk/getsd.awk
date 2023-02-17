#!/usr/bin/awk
BEGIN{FS="/";x=2}
function none() {print "main";exit}
NF==1{none()}
/\.\//{x++}
$x~/\.(txti|html|org|md)/{none()}
{if($x=="dnd")none();print $x;exit}
