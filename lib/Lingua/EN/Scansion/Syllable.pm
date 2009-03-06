package Lingua::EN::Scansion::Syllable;

use warnings;
use strict;
use Carp;

=head1 NAME

Lingua::EN::Scansion::Syllable - The great new Lingua::EN::Scansion::Syllable!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Datastructure helper class for C<Lingua::EN::Scansion>.

TO DO: document some of its uses.

=cut

# CLASS initialization: build and keep around one of each of these

use Lingua::EN::Phoneme;
my $LEP = Lingua::EN::Phoneme->new();

use Text::Hyphen;
my $HYPHENATOR = Text::Hyphen->new();

our $VERBOSE;

=head1 CLASS METHODS

=over

=item new

initialize a new syllable object.  Takes k/v pairs as arguments, including

=over

=item spelled

the syllable's chunk for hyphenation

=item vowel

the vowel from this syllable, as retrieved from C<Lingua::EN::Phoneme>.

=back

=cut

sub new {
  my $class = shift;
  my %args = @_;
  return bless \%args, $class;
}


=item syllabify

given a word (as string), returns syllable objects that pronounce that word.

Ideally, the syllable objects that it constructs will have spelling
and pronunciation keys, depending on what the various dictionary and
hyphenation tools can provide.

=cut

sub syllabify {
  my $class = shift;
  my %args = @_;

  my $word = $args{word};

  $word =~ s/\p{isPunctuation}+$//;
  $word =~ s/^\p{isPunctuation}+//;

  return () if $word =~ /^\s*$/;

  my @spelled_sylls = split /-/, $HYPHENATOR->hyphenate($word);

  my $phonemes = $LEP->phoneme($word);
  my @phonemes;
  if (defined $phonemes) {
    @phonemes = split " ", $phonemes;
  }
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


=back

=head1 INSTANCE METHODS

=over

=back

=head1 AUTHOR

Jeremy G. KAHN, C<< <kahn at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-lingua-en-scansion-syllable at rt.cpan.org>, or through the web
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

1; # End of Lingua::EN::Scansion::Syllable
