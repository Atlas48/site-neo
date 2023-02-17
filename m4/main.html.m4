dnl template.m4.html v2.0-p1
dnl Part of the tape-and-string suite used to construct the website
ifdef(`DEBUG',`traceon')dnl
# ifdef(`_INFILE',`dnl ',`errprint(`Macro _INFILE is not defined')
# m4exit(1)')dnl
include(`lib.m4')dnl
include(`linkdata.m4')dnl
define(`_la',`_a(`argn(`1',$1),argn(`2',$1)')
<!DOCTYPE html>
<html>
<head>
<style>
@import url("/css/CSSI().css'");
</style>
<title>TITLE</title>
</head>
<body>
<div class="header">
stack_foreach(`_LINK',`_la')
<a href="/">Home</a>
</div>
<div class="content">
# esyscmd(`./tape.sh' _INFILE)dnl
</div>
</body>
</html>
