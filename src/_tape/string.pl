#!/usr/bin/env perl
use strict; use warnings;
use File::Slurp; use File::Basename;
push(@INC,dirname(__FILE__));
use tape;
my $fi = $ARGV[1];
if(substr($fi,0,1)=='_') {
  print STDERR "Skipping file: $fi, ignored.";
  exit 0;
}
my @fc = split(/\./, $fi);
my $fo = $fc[0].'.html';
if(!exists($fc{$fc[1]}) {
	print STDERR "Skipping file: $fi, no way to process extension.";
	exit 1;
}
my $out=tape::render{$fc[1]}(read_file($fi);
open $of, ">_tmp";
if(exists($tape::titles{$fi})) {
  print $of `m4 -DTITLE=$tape::titles{$fi} main.html.m4<<.
$out
.`;
}
close $of;
