divert(-1)
# extra macros for site structure
define(`_ytv',`<iframe width="ifdef(`$3',$1,560)" height="ifdef(`$3',$3,315)" src="$1" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
define(`_wrap',<$1>$2</$1>)
define(`_empty',`')
divert dnl
