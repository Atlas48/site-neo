dnl template.m4.html v2.0-p1
dnl Part of the tape-and-string suite used to construct the website
ifdef(`DEBUG',`traceon')dnl
ifdef(`_INFILE',`dnl ',`errprint(`Macro _INFILE is not defined')
m4exit(1)')dnl
include(`m4/lib.m4')dnl
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
esyscmd(`awk -f awk/getlinks.awk dat/links.csv')dnl
</div>
<div class="content">
esyscmd(`./tape.sh' _INFILE)
</div>
</body>
</html>
