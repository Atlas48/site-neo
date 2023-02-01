declare -A prog
prog[m4]=`readlink -f main.html.m4`
prog[title]=`readlink -f titlelookup`
function tape {
  case $1 in
	*.txti) redcloth $1 ;;
	*.org) org-ruby --translate html $1 ;;
	*.md) comrak --gfm $1 ;;
	*.html) cat $1
	*) pandoc --cols 168 -t html $i || echo "Unable to render $i, unknown format" ;;
  esac
}
