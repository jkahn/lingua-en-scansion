package Lingua::EN::Scansion;

use strict;
use warnings;
use Carp;

use 5.006;  # seems safe to require at least 5.6.

=head1 NAME

Lingua::EN::Scansion - English language poetry scansion analysis

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
use Lingua::EN::Scansion::Line;
use Lingua::EN::Scansion::Word;
use Lingua::EN::Scansion::Syllable;

sub pretty_print {
  my $class = shift;
  my %args = @_;
  my $title = $args{title};
  my @formatted;
  for my $line (@{$args{lines}}) {
    my @words = map { $_->word } $line->words();
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
    my $target_length = $len - $overrun; $overrun = 0;

    my $line =
      Lingua::EN::Scansion::Line->new_from_word_stream(words => \@words,
						       syll_length =>
						       $target_length);
    push @lines, $line;
    my $sylct = $line->syllable_count();
    if ($sylct > $len) {
      $overrun = $sylct - $len;
    }
  }
  return @lines;
}


=head1 AUTHOR

Jeremy G. KAHN, C<< <kahn at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-lingua-en-scansion
at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Lingua-EN-Scansion>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.




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
