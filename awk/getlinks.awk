BEGIN{FS=","}
{print "<a href=\"" $1 "\">" $2 "</a>"}
