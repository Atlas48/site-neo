dnl template.m4.html v1.3-p1
dnl Part of the tape-and-string suite used to construct the website
include(`m4/lib.m4')dnl
ifdef(`CSS_INC',`', define(`CSS_INC', `main'))dnl
ifelse(CSS_INC,`dnd',define(`CSS_INC',`main'))dnl
define(`_CSS',`/css/CSS_INC.css')dnl
<!DOCTYPE html>
<html>
<head>
<style>
@import url("_CSS");
</style>
<title>TITLE</title>
</head>
<body>
<div class="header">
<a href="/">Home</a>
</div>
<div class="content">
include(`/dev/stdin')dnl Probably not a good idea, but whatever.
</div>
</body>
</html>
