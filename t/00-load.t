#!perl

use Test::More tests => 1;

BEGIN {
	use_ok( 'Judy' );
}

diag( "Testing Judy $Judy::VERSION, Perl $], $^X" );
