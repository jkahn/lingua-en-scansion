package Lingua::EN::Scansion::Line;

use warnings;
use strict;
use Carp;

=head1 NAME

Lingua::EN::Scansion::Line - The great new Lingua::EN::Scansion::Line!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Datastructure helper class for C<Lingua::EN::Scansion>.

TO DO: more documentation of what it's for.

=head1 CLASS METHODS

=over

=item new

k/v pairs as argument. Expects at least C<words> key, which should
have a listref.

=cut

sub new {
  my $class = shift;
  my %args = @_;
  if (not defined $args{words} or ref $args{words} ne 'ARRAY') {
    carp "$class did not get words key, or words key has a non-listref value";
  }
  my $self = bless \%args, $class;
  return $self;
}

=item new_from_word_stream

takes k/v pairs with keys C<words> (value is ref to wordlist) and
C<syll_length> (value is number of syllables).

constructs a new C<L:E:S:Line> object from a prefix of the
word-stream.  The new object will have a syllable length of
C<syll_length>.

modifies the referred-to array by removing C<syll_length> syllables
from it.

=cut

sub new_from_word_stream {
  my $class = shift;
  my %args = @_;
  my $length = $args{syll_length};
  my $wordlist = $args{words};
  my $self = $class->new( words => []);
  while ($self->syllable_count < $length) {
    my $next_word = shift @$wordlist;
    last if not defined $next_word;
    $self->append_word($next_word);
  }
  return $self;
}


=back

=head1 INSTANCE METHODS

=over

=item syllable_count

total number of syllables this line

=cut

sub syllable_count {
  my $self = shift;
  my $ct = 0;
  $ct += $_->sylls() for $self->words();
  return $ct;
}

=item words

C<Lingua::EN::Scansion::Word> objects

=cut

sub words {
  my $self = shift;
  return @{$self->{words}};
}

=item append_word

add a C<Lingua::EN::Scansion::Word> object to the end of the line. 

Returns items appended. (I guess? not using this)

=cut

sub append_word {
  my $self = shift;
  for my $word (@_) {
    my $type = ref $word;
    carp "$type object passed to append word not a L:E:S:Word"
      unless $word->isa('Lingua::EN::Scansion::Word');
    push @{$self->{words}}, $word;
  }
  return @_;
}

=back

=head1 AUTHOR

Jeremy G. KAHN, C<< <kahn at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-lingua-en-scansion-line at rt.cpan.org>, or through
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

Copyright 2009 Jeremy G. KAHN, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Lingua::EN::Scansion::Line
