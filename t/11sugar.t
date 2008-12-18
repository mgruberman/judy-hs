#!perl
use strict;
use warnings;
use Test::More tests => 10;
use Judy::HS qw( Duplicates );

my $judy = 0;

for ( 0 .. 9 ) {
    is( Duplicates( $judy, 'x', ), $_ )
}
