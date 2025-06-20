# Atlas48's Neocities Archives
Welcome to the technical documentation for my [Neocities](https://neocities.org) page, which also contains a rudimentary static site generator cobbled together out of unix tools,
and Ruby scripts, that I've taken to calling the "tape-and-string" framework for obvious reasons.

# License
All markup is licensed under the Creative Commons [Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license.

Any runnable computer code or Sass/CSS definitions are licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html)

All fonts belong to their respective owners.
# Specification
## Dependencies
You will need the following tools to render and upload the site
- A [Ruby](https://www.ruby-lang.org/en/) interpreter
- [RedCloth](http://redcloth.org/)
- [org-ruby](http://github.com/bdewey/org-ruby)
- [comrak](https://github.com/kivikakk/comrak)
## `Makefile`
Wraps `render.sh` for the most part.
### Makefile Options
#### `list`
Lists all components in a heading-annotated list
#### `list-{doc,sass,dir,rest}`
Lists markup files, sass files, directories, and other files respectively.
#### `clean`
Removes the `out/` directory that is generated on running of `render.sh`.
## `render.sh`
The primary worker script, sets up the directory structure, transpiles the markup, then the Sass, then copies the contents of `in/` to `out/`
