#!perl
use strict;
use warnings;
use Test::More tests => 22;
use Judy::HS qw( Set Delete Get Free );

use constant PTR => join '', 'P', length pack 'J', 0;

sub deref { ! defined $_[0] ? undef : unpack 'J', unpack PTR, pack 'J', $_[0] }
{
    my $judy = 0;
   
    {
	my($ptr,$val) = Get( $judy, 'a' );
	is( $judy, 0, q(Judy doesn't exist until added to) );
	is( $ptr, 0, q(Can't fetch pointers from non-existant Judy) );
	is( $val, undef, q(Can't fetch values from nonexistant Judy) );
    }

    {
	my $ptr = Set( $judy, 'a', 23 );
	isnt( $judy, 0, 'Judy is true' );
	is( deref( $ptr ), 23, 'Setting a=23' );
    }

    {
	my $ptr0 = Set( $judy, 'a', 42 );
	is( deref( $ptr0 ), 42, 'Setting a=42' );
	my($ptr1,$val) = Get( $judy, 'a' );
	is( $ptr1, $ptr0, 'Pointers returned by Set and Get are the same' );
	is( $val, 42, 'Fetched a=42' );
	is( deref( $ptr1 ), 42, 'Fetched and dereferenced a=42' );
	
	(my($ptr2),$val) = Get( $judy, 'a' );
	is($ptr2,$ptr1, 'Pointers returned by subsequent Get calls are identical' );
	is( $val, 42, 'Fetched a=42' );
	is( deref( $ptr2 ), 42, 'Fetched and dereferenced a=42' );
    }

    {
	my $deleted = Delete( $judy, 'a' );
	is( $deleted, 1, 'Deleted a=42' );
    }
    
    {
    	my( $ptr, $val ) = Get( $judy, 'b' );
    	is( $ptr, 0, 'Fetched NULL pointer for deleted things' );
    	is( $val, undef, 'Fetched undef value for deleted things' );
    }

    {
    	my $deleted = Delete( $judy, 'a' );
    	is( $deleted, 0, q(Can't delete a=42 because it was already deleted) );
    }

    {
	my ( $ptr, $val ) = Get( $judy, 'b' );
	is( $ptr, 0, 'Fetched NULL pointer for deleted things' );
	is( $val, undef, 'Fetched undef value for deleted things' );

	my $deleted = Delete( $judy, 'b' );
	is( $deleted, 0, q(Can't delete things that haven't been added) );
    }

    {
	my $freed = Free( $judy );
	is( $judy, 0, 'Judy is free' );
    }

    {
	my $ptr = Set( $judy, 'c', 2010 );
	my $freed = Free( $judy );
	is( $judy, 0, 'Judy is free' );
	isnt( $freed, 0, 'Judy freed something' );
    }
}
