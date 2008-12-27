#!perl
use strict;
use warnings;
use Test::More;
use Judy::Mem qw( Peek );
use Judy::L qw( Set Get Free );
use Config '%Config';

if ( ( $Config{ivsize} == $Config{longsize} )
   && ( $Config{uvsize} == $Config{longsize} )
   ) {
   plan( skip_all => 'sizeof(IV) == sizeof(long), hurrah' );
}
else {
     plan( tests => 1 );
}

my $judy;

my $warned = '';
$SIG{__WARN__} = sub { $warned = shift @_ };
Set($judy,0, 4294967360 );
like( $warned, qr/\(UV\)4294967360 truncated to \(Word_t\)64/ )