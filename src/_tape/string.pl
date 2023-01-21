#!/usr/bin/env perl
use strict; use warnings;
use "dat.pl";
use Text::Textile;
use Text::Markdown;
use Org::To::HTML
if($ARGV[1][0]=='_') {
  print STDERR "Skipping file: $ARGV[1], ignored.";
  exit 0;
}
my @fi = split(/\./, $ARGV[1])
if(!exists($fn{$fi[1]}) {
	print STDERR "Skipping file: $ARGV[1], no way to process extension.";
	exit 1;
}
open $if, "<$ARGV[1]";
open $of, ">_tmp";
$fn{$fi[1]}($if);
close $if;
close $of;
