package Lingua::EN::Haiku;

use base 'Lingua::EN::Scansion';
our $VERBOSE = 0;

sub new {
  my $class = shift;

  my @wds = map { Lingua::EN::Scansion::Word->new($_) } @_;

  use List::Util 'sum';
  my $syllct = sum map { scalar $_->sylls() } @wds;

  if ($syllct != 17) {
    die "found $syllct sylls instead of 17\n";
    # TO DO: better warnings about haiku-ishness
  }

  my @lines = $class->lines_by_syllcts(break_hyphen => 1,
				       syllcts => [5,7,5],
				       words => \@wds, 
				       verbose => $VERBOSE);

  my $title = join " ", map {ucfirst $_->word()} @{$lines[0]};

  return bless {lines => \@lines, title => $title};
}
sub pretty_print {
  my $self = shift;
  return $self->SUPER::pretty_print(title => $self->{title},
				    lines => $self->{lines});
}

1;
