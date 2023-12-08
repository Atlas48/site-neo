#!/usr/bin/ruby
# pfiles.rb
# v1.1-p1
abort "\x1B[1;31mERR\x1B[0m: No arguments supplied" if ARGV.length == 0
require 'find'
ignore=!File.file?('dat/ignore.txt') ? [] : File.readlines('dat/ignore.txt')
if ignore != []
	ignore.map! { |i| "in/#{i}" }
end
class Enumerator
	def collect
		out=Array.new
		for i in self
			out.push(i)
		end
		return out
	end
end
l=Find.find('in').collect
case ARGV.first
when "doc"
	for i in l do
		next if ignore.include?(i) or /(?<!\.e)\.html$/.match?(i)
		if /\.(txti|org|md|e.html)$/.match?(i)
			print i
			print ' ' unless i==l.last
		end
	end
when "sass"
	for i in l do
		next if ignore.include?(i)
		if /\.s[ac]ss$/.match?(i)
			print i
			print ' ' unless i==l.last
		end
	end
when "dir"
	for i in l do
		next if ignore.include?(i) or i == ".git"
		if File.directory?(i)
			print i
			print ' ' unless i==l.last
		end
	end
when "rest"
	for i in l do
		next if ignore.include?(i)
		unless /\.(s[ac]ss|txti|org|md|html)$/.match?(i) or File.directory?(i)
			print i
			print ' ' unless i==l.last
		end
	end
else
	abort "\x1B[1;31mERR\x1B[0m: Unknown option: #{ARGV.first}"
end
