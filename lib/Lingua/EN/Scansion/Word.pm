package Lingua::EN::Scansion::Word;

use warnings;
use strict;
use Carp;

=head1 NAME

Lingua::EN::Scansion::Word - The great new Lingua::EN::Scansion::Word!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

A datastructure helper class for C<Lingua::EN::Scansion>.

TO DO: a sample use?

=head1 CLASS METHODS

=over

=item new

given a single English word, constructs a self (with syllable
substructure by asking C<Lingua::EN::Scansion::Syllable> for help)

=cut


sub new {
  my $class = shift;
  my $word = shift;

  my @sylls =
    Lingua::EN::Scansion::Syllable->syllabify(word => $word);
  return bless { sylls => \@sylls,
		 word => $word }, $class;
}

=back

=head1 INSTANCE METHODS

=over

=item word

returns original word (string) form

=cut

sub word {
  my $self = shift;
  return $self->{word};
}

=item sylls

returns C<Lingua::EN::Syllable> objects associated with this word

=cut

sub sylls {
  my $self = shift;
  return @{$self->{sylls}};
}

=item debug

returns string form representing serialization of word and substructure

=cut

sub debug {
  my $self = shift;
  # TO DO: fix this up to use Syllable structure properly?
  return join "~", $self->sylls();
}

=back

=head1 AUTHOR

Jeremy G. KAHN, C<< <kahn at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-lingua-en-scansion-word at rt.cpan.org>, or through the web
interface at
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

Copyright 2009 Jeremy G. KAHN, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Lingua::EN::Scansion::Word
