package Judy::HS;

use strict;
use warnings;

BEGIN {
    our $VERSION = '0.01';

    require XSLoader;
    XSLoader::load(__PACKAGE__,$VERSION);
}

use Sub::Exporter -setup => {
    exports => [qw[ JHSI JHSD JHSG JHSFA ]],
};

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'

__END__

=head1 NAME

Judy::HS - Library for creating and accessing a dynamic array, using an array-of-bytes of Length as an Index and a word as a Value. 



=head1 SYNOPSIS

Shows an ultra-cheap hash for removing duplicates.

  my $judy = 0;
  while (<>) {
    JHSI( my( $value ), $judy, $_, length );
    print if ! $value;
  }



=head1 DESCRIPTION

Judy::HS is an interface to the JudyHS macros in the Judy array library.

A JudyHS array is the equivalent of an array of word-sized
value/pointers. An Index is a pointer to an array-of-bytes of
specified length: Length. Rather than using a null terminated string,
this difference from JudySL(3X) allows strings to contain all bits
(specifically the null character). This new addition (May 2004) to
Judy arrays is a hybird using the best capabilities of hashing and
Judy methods. JudyHS does not have a poor performance case where
knowledge of the hash algorithm can be used to degrade the
performance.

Since JudyHS is based on a hash method, Indexes are not stored in any
particular order. Therefore the JudyHSFirst(), JudyHSNext(),
JudyHSPrev() and JudyHSLast() neighbor search functions are not
practical. The Length of each array-of-bytes can be from 0 to the
limits of malloc() (about 2GB).

The hallmark of JudyHS is speed with scalability, but memory
efficiency is excellent. The speed is very competitive with the best
hashing methods. The memory efficiency is similar to a linked list of
the same Indexes and Values. JudyHS is designed to scale from 0 to
billions of Indexes.

A JudyHS array is allocated with an undefined or 0 value.

    my $PJHSArray = 0;



=head1 EXPORT

All functions are exportable by L<Sub::Exporter>.



=head1 RAW FUNCTIONS

The following functions follow the C macro API as closely as
possible. I don't yet know how to meaningfully have modifiable
C<$PValue> pointers.

The values below are hopefully mapped to useful Perl analogues. The
sole exception is C<$PValue> which is just exposed as a numified
pointer. This will hopefully change to be more useful.

  Word_t  * PValue;                           // JudyHS array element
  int       Rc_int;                           // return flag
  Word_t    Rc_word;                          // full word return value
  Pvoid_t   PJHSArray = (Pvoid_t) NULL;       // initialize JudyHS array
  uint8_t * Index;                            // array-of-bytes pointer
  Word_t    Length;                           // number of bytes in Index

=head2 JHSI( $Value, $PJHSArray, $Index, $Length ) // JudyHSIns()

Given a pointer to a JudyHS array (C<$PJHSArray>), insert an C<$Index>
string of length: C<$Length> and a C<$Value> into the JudyHS array:
C<$PJHSArray>. If the C<$Index> is successfully inserted, the
C<$Value> is initialized to 0. If the C<$Index> was already present,
the C<$Value> is not modified.

TODO: document and figure out how to do something meaningful from
Perl. This part is just the C documentation and not meaningful for use
in Perl. Return PValue pointing to Value. Your program should use
this pointer to read or modify the Value, for example:

 Value = *PValue;
 *PValue = 1234;

=pod

Note: JHSI() and JHSD can reorganize the JudyHS array. Therefore,
pointers returned from previous JudyHS calls become invalid and must
be re-acquired (using JHSG()).

=head2 JHSD($Rc_int, $PJHSArray, $Index, $Length) // JudyHSDel()

Given a pointer to a JudyHS array (C<$PJHSArray>), delete the
specified C<$Index> along with the C<$Value> from the JudyHS array.

Return C<$Rc_int> set to 1 if successfully removed from the
array. Return C<$Rc_int> set to 0 if C<$Index> was not present.

=head2 JHSG($PValue, $PJHSArray, $Index, $Length) // JudyHSGet()

Given a pointer to a JudyHS array (C<$PJHSArray>), find C<$Value>
associated with C<$Index>.

Return C<$PValue> pointing to C<$Index>'s Value. Return C<$PValue> set
to NULL if the C<$Index> was not present.

=head2 JHSFA($Rc_word, $PJHSArray) // JudyHSFreeArray()

Given a pointer to a JudyHS array (C<$PJHSArray>), free the entire array.

Return C<$Rc_word> set to the number of bytes freed and C<$PJHSArray>
set to NULL.



=head1 AUTHOR

Joshua ben Jore, C<< <jjore at cpan.org> >>

JudyHS was invented and implemented by Doug Baskins after retiring from Hewlett-Packard.



=head1 SOURCE AVAILABILITY

This source is in Github: L<git://github.com/jbenjore/judy-hs.git>



=head1 BUGS

Please report any bugs or feature requests to C<bug-Judy-HS at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Judy-HS>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.



=head1 SUPPORT

You can find documentation for this module with the perldoc command.

  perldoc Judy::HS

You can also look for information at:

=over

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Judy::HS>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Judy::HS>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Judy::HS>

=item * Search CPAN

L<http://search.cpan.org/dist/Judy::HS/>

=back



=head1 ACKNOWLEDGEMENTS

Doug Baskins, totally.



=head1 COPYRIGHT & LICENSE

Copyright 2008 Joshua ben Jore, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
