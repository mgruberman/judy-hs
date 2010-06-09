#!perl
use Test::More tests => 1;
require Judy;
pass('Loaded Judy');
diag( "Testing Judy $Judy::VERSION, Perl $], $^X" );
