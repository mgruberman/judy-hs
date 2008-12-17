#!perl

use Test::More tests => 1;

BEGIN {
	use_ok( 'Judy::HS' );
}

diag( "Testing Judy::HS $Judy::HS::VERSION, Perl $], $^X" );
