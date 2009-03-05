package Lingua::EN::Scansion;

use strict;
use warnings;
use Carp;

=head1 NAME

Lingua::EN::Scansion - English language poetry scansion analysis

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


sub pretty_print {
  my $class = shift;
  my %args = @_;
  my $title = $args{title};
  my @formatted;
  for my $line (@{$args{lines}}) {
    my @words = map { $_->word } @{$line};
    $words[0] = ucfirst $words[0];
    push @formatted, join " ", @words;
  }

  use List::Util 'max';
  my $divider = '-' x max (map { length $_ } @formatted);
  return join ("\n", $title, $divider, @formatted);
}

sub lines_by_syllcts {
  my $class = shift;
  my %args = @_;

  my @syllcts = @{$args{syllcts}};
  my @words = @{$args{words}};

  my @lines;
  my $overrun = 0;
  for my $len (@syllcts) {
    my @line;
    my $so_far = $overrun; $overrun = 0;
    while ($so_far < $len) {
      my $next_wd = shift @words;
      my $ct = scalar $next_wd->sylls();
      if ($so_far + $ct > $len) {
	$overrun = $so_far + $ct - $len;
	warn "line-break needed in " . $next_wd->debug . "\n"
	  if $args{verbose};
      }
      push @line, $next_wd;
      $so_far += $ct;
    }
    push @lines, \@line;
  }
  return @lines;
}

package Lingua::EN::Scansion::Word;

use strict;
use warnings;
use Carp;

# use overload '""' => \&stringify;

sub new {
  my $class = shift;
  my $word = shift;


  my @sylls =
    Lingua::EN::Scansion::Syllable->syllabify(word => $word);
  return bless { sylls => \@sylls,
		 word => $word }, $class;
}

sub word {
  my $self = shift;
  return $self->{word};
}

sub sylls {
  my $self = shift;
  return @{$self->{sylls}};
}

sub debug {
  my $self = shift;
  return join "~", $self->sylls();
}


package Lingua::EN::Scansion::Syllable;
use strict;
use warnings;
use Carp;

our $VERBOSE = 1;

use overload '""' => \&stringify;

use Lingua::EN::Phoneme;
my $LEP = Lingua::EN::Phoneme->new();

use Text::Hyphen;
my $HYPHENATOR = Text::Hyphen->new();

sub syllabify {
  my $class = shift;
  my %args = @_;

  my $word = $args{word};

  $word =~ s/\p{isPunctuation}+$//;
  $word =~ s/^\p{isPunctuation}+//;

  return () if $word =~ /^\s*$/;

#   use Lingua::EN::Hyphenate 'syllables';
#   my @spelled_sylls = syllables($word);

  my @spelled_sylls = split /-/, $HYPHENATOR->hyphenate($word);

  my @phonemes = $LEP->phoneme($word);
  my @vowels = grep {/[012]$/} @phonemes;

  if (not @phonemes) {
    warn "no phonemes for $args{word}\n";
    return
      map { $class->new(spelled => $_) }
	@spelled_sylls;
  }

  # otherwise we have phonemes
  if (@vowels != @spelled_sylls and $VERBOSE) {
    warn "mismatch between #vowels (" . scalar @vowels .
      ") and #spelled_sylls " . join ('~', @spelled_sylls) . " in $word\n";
  }

  # trust the vowels more.  TO DO: better alignments.
  my @out;
  while (@vowels) {
    my $vowel = shift @vowels;
    my $spelled = shift @spelled_sylls;
    if (not defined $spelled) {
      $spelled = '';
    }
    if (@spelled_sylls and not @vowels) {
      $spelled .= join ('', @spelled_sylls);
    }
    push @out, $class->new(spelled => $spelled, vowel => $vowel);
  }
  return @out;
}

sub new {
  my $class = shift;
  my %args = @_;
  return bless \%args, $class;
}
sub stringify {
  my $self = shift;
  return $self->{spelled};
}

=head1 AUTHOR

Jeremy G. KAHN, C<< <kahn at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-lingua-en-scansion at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Lingua-EN-Scansion>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lingua::EN::Scansion


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Lingua-EN-Scansion>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Lingua-EN-Scansion>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Lingua-EN-Scansion>

=item * Search CPAN

L<http://search.cpan.org/dist/Lingua-EN-Scansion>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Jeremy G. KAHN .

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Lingua::EN::Scansion
