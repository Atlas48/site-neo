package tape;
use strict; use warnings;
use Text::Textile;
use Text::Markdown;
use Org::Parser; use Org::To::HTML;
use CSS::Sass;
use Exporter qw(Export);
use constant {
  true => 1,
  false => 0
}
our @EXPORT = qw(render titles);
sub scss {
  my $sassc = CSS::Sass->new;
  return $sassc->compile($_[0])[0];
}
my %render = (
  'txti' => sub {
    my $p = Text::Textile->new;
	$p->css(false);
	return $p->process($_[0]);
  },
  'md' => sub {
    my $p = Text::Markdown->new;
	return $p->markdown($_[0]);
  },
  'org' => sub {
    my $p = Org::Parser->new;
    my $o = Org::To::HTML->new;
	return $o->export_document($p->parse($_[0]));
  },
  'sass' => sub {
    return scss(sass2scss($_[0]));
  },
  'scss' => &scss
);
my %titles = (
  "not_found.txti" => "404 - Page Not Found",
  "index.txti" => "Atlas48's Archives"
);
