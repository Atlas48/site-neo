#!/usr/bin/ruby
ignore=!File.file?('ignore.txt') ? [] : File.readlines('ignore.txt')
switch $ARGV[1]

end
