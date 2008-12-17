#!perl
use strict;
use warnings;
use Test::More tests => 11;
use Judy::HS qw( JHSI JHSD JHSG JHSFA );

{
    my $judy = 0;
    {
	my $val = 0;
	JHSI( $val, $judy, 'a', 1 );
	isnt( $judy, 0, 'PJHSArray is initialized' );
	is( $val, 0, 'value is new' );
    }

    {
	my $fetch0 = 42;
	JHSI( $fetch0, $judy, 'a', 1 );
	isnt( $fetch0, 0, 'value exists' );
	
	my $fetch1 = 43;
	JHSG( $fetch1, $judy, 'a', 1 );
      TODO: {
	  local our $TODO = 'Fails';
	  is( $fetch1, 42, 'Fetched previous value' );
	}
    }

    {
	my $rc = 44;
	JHSD( $rc, $judy, 'a', 1 );
	is( $rc, 1, 'Deleted' );
    }
    
    {
	my $fetch = 45;
	JHSG( $fetch, $judy, 'a', 1 );
	TODO: {
	    local our $TODO = 'Fails';
	    is( $fetch, 0, 'Deleted things are gone' );
	}
    }

    {
	my $rc = 46;
	JHSD( $rc, $judy, 'a', 1 );
	is( $rc, 0, 'Deleted things stay gone' );
    }

    {
	my $fetch = 47;
	JHSG( $fetch, $judy, 'b', 1 );
	TODO: {
	    local our $TODO = 'Fails';
	    is( $fetch, 0, q(Missing things aren't there) );
        }

        my $rc = 48;
	JHSD( $rc, $judy, 'b', 1 );
	is( $rc, 0, q(Missing things can't be deleted) );
    }

    {
	my $rc = 49;
	JHSFA( $rc, $judy );
      TODO: {
	    local our $TODO = 'Fails';
	    isnt( $rc, 0, 'Freed something' );
	}
	is( $judy, 0, 'Judy is free' );
    }
}
