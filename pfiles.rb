#!/usr/bin/ruby
require 'find'
ignore=!File.file?('ignore.txt') ? [] : File.readlines('ignore.txt')
if ignore != []
  ignore.map! do |i|
    "in/#{i}"
  end
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
list=Find.find('in')
l=list.collect
case ARGV.first
when "doc"
  for i in l do
    next if ignore.include?(i)
    if /\.(txti|org|md|html)$/.match?(i)
      print i
      print ' ' unless i==l.last
    end
  end
when "scass"
  for i in l do
    next if ignore.include?(i)
     if /\.s[ac]ss$/.match?(i)
      print i
      print ' ' unless i==l.last
     end
  end
when "sass"
  for i in l do
    next if ignore.include?(i)
     if /\.sass$/.match?(i)
      print i
      print ' ' unless i==l.last
     end
  end
when "scss"
  for i in l do
    next if ignore.include?(i)
     if /\.scss$/.match?(i)
      print i
      print ' ' unless i==l.last
     end
  end
when "dir"
  for i in l do
    next if ignore.include?(i)
    if File.directory?(i)
      print i
      print ' ' unless i==l.last
    end
  end
when "rest"
  for i in l do
    next if ignore.include?(i)
    unless /\.(s[ac]ss|txti|org|md)$/.match?(i) or File.directory(i)
      print i
      print ' ' unless i==l.last
    end
  end
else
end
