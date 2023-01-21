package tape;
use strict; use warnings;
use Exporter qw(Export);
our @EXPORT = qw(fn titles);
my %fn = (
  'txti' => sub {
  },
  'md' => sub {
  },
  'org' => sub {
  }
);
my %titles = (
  "not_found.txti" => "404 - Page Not Found",
  "index.txti" => "Atlas48's Archives"
);
