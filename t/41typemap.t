#!perl
use strict;
use warnings;
use vars '@MAGIC';
use Test::More 'no_plan';
use Judy::Mem qw( String2Ptr Ptr2String Ptr2String2 Free );

tie my($magic), 'MAGIC';
@MAGIC = ();

$|=1;
use Data::Dumper;
sub X { print Dumper([\@MAGIC,${tied($magic)}]); @MAGIC = () }
sub RunTest (&) {
    local @MAGIC;
    &{$_[0]};
}    

# Pvoid_t #####################################################################
RunTest {
    $magic = MAGIC::set_Pvoid_t1();
    is_deeply( \@MAGIC, [['STORE',undef,3]], 'Set Pvoid_t via RETVAL' );
    is( ${tied $magic}, 3, 'Set Pvoid_t via RETVAL' );
};

RunTest {
    MAGIC::get_Pvoid_t( $magic );
    is_deeply( \@MAGIC, [['FETCH',3]], 'Fetch Pvoid_t' );
    is( ${tied $magic}, 3, 'Fetch Pvoid_t' );
};

RunTest {
    MAGIC::set_Pvoid_t2( $magic );
    is_deeply( \@MAGIC,[['FETCH',3],
			['STORE',3,4]], 'Set Pvoid_t via OUTPUT:' );
    is( ${tied $magic}, 4, 'Set Pvoid_t via OUTPUT:' );
};

# Word_t #####################################################################
${ tied $magic } = 5;
RunTest {
    MAGIC::get_Word_t( $magic );
    is_deeply( \@MAGIC, [['FETCH',5]], 'Fetch Word_t' );
    is( ${tied $magic}, 5, 'Fetch Word_t' );
};

RunTest {
    $magic = MAGIC::set_Word_t1();
    is_deeply( \@MAGIC,[['STORE',5,6]], 'Set Word_t via RETVAL' )
	or diag( Dumper( \ @MAGIC ) );
    is( ${tied $magic}, 6, 'Set Word_t via RETVAL' );
};
RunTest {
    MAGIC::set_Word_t2( $magic );
    is_deeply( \@MAGIC,[['FETCH',6],
    			['STORE',6,7]], 'Set Word_t via OUTPUT:' );
    is( ${tied $magic}, 7, 'Set Word_t via OUTPUT:' );
};

# PWord_t ######################################################################
${ tied $magic } = 8;
RunTest {
    MAGIC::get_PWord_t( $magic );
    is_deeply( \@MAGIC, [['FETCH',8]], 'Fetch PWord_t' );
    is( ${tied $magic}, 8, 'Fetch PWord_t' );
};

RunTest {
    $magic = MAGIC::set_PWord_t1();
    is_deeply( \@MAGIC,[['STORE',8,9]], 'Set PWord_t via RETVAL' )
	or diag( Dumper( \ @MAGIC ) );
    is( ${tied $magic}, 9, 'Set PWord_t via RETVAL' );
};

RunTest {
    MAGIC::set_PWord_t2( $magic );
    is_deeply( \@MAGIC,[['FETCH',9],
    			['STORE',9,10]], 'Set PWord_t via OUTPUT:' );
    is( ${tied $magic}, 10, 'Set PWord_t via OUTPUT:' );
};

# Str #####################################################################
RunTest {
    ${tied $magic} = "aa\0bb";
    MAGIC::get_Str( $magic );
    is_deeply( \@MAGIC, [['FETCH',"aa\0bb"]], 'Fetch Str' );
};

RunTest {
    $magic = MAGIC::set_Str1();
    is_deeply( \@MAGIC, [['STORE',"aa\0bb","bb\0cc"]], 'Set Str via RETVAL' );
};

RunTest {
    MAGIC::set_Str2( $magic );
    is_deeply( \@MAGIC, [['FETCH',"bb\0cc"],
			 ['STORE',"bb\0cc","cc\0dd"]], 'Set Str via OUTPUT' );
};

RunTest {
    $magic = MAGIC::set_Str3();
    is_deeply( \@MAGIC, [['STORE',"cc\0dd",'ee']], 'Set Str via RETVAL w/ implicit length' );
};

RunTest {
    MAGIC::set_Str4( $magic );
    is_deeply( \@MAGIC, [['FETCH','ee'],
			 ['STORE','ee','ff']], 'Set Str via OUTPUT w/ implict length' );
};

######################################################################
# RunTest {
#     ${ tied $magic } = 'hi';
#     Free( String2Ptr( $magic ) );
#     is_deeply( \@MAGIC,[['FETCH','hi']],'String2Ptr GET');
# };
# 
# ${ tied $magic } = undef;
# RunTest {
#     $magic = String2Ptr( 'hi' );
#     like( ${tied $magic}, qr/^[1-9]\d+\z/, 'String2Ptr SET RETVAL' );
#     is_deeply( \@MAGIC, [['STORE',undef,${tied $magic}]], 'String2PTR SET RETVAL' );
#     Free( ${ tied $magic } );
# };
# 
# RunTest {
#     ${tied $magic} = String2Ptr( 'bye' );
#     Ptr2String( $magic );
#     like( ${tied $magic}, qr/^[1-9]\d+\z/, 'Ptr2String );
#     is_deeply( \@MAGIC, [['FETCH',${tied $magic}]] );
#     Free( ${ tied $magic } );
# };

package MAGIC;
use lib 'inc';
use My::Paths;
sub TIESCALAR {
    my ( $class ) = @_;
    bless do { \ my $scalar }, $class;
}
sub FETCH   { push @::MAGIC, [FETCH=>${$_[0]}]; ${$_[0]}         }
sub STORE   { push @::MAGIC, [STORE=>${$_[0]},$_[1]]; ${$_[0]} = $_[1] }
sub UNTIE {}
sub DESTROY {}

use Inline C => <<'.', INC => join( ' ', @{My::Paths::CCINC()} ), LIBS => join( ' ', @{My::Paths::CCLIB()}, '-lJudy' ), NAME => 'MAGIC', XSMODE => 1, CLEAN_BUILD_AREA => 0, CLEAN_AFTER_BUILD => 0, TYPEMAPS => ['typemap'];
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "Judy.h"
#include "pjudy.h"

MODULE = MAGIC PACKAGE = MAGIC PREFIX = magic_

PROTOTYPES: DISABLE

void
magic_get_Pvoid_t( x )
        Pvoid_t x
    CODE:

Pvoid_t
magic_set_Pvoid_t1()
    CODE:
        RETVAL = 3;
     OUTPUT:
        RETVAL

void
magic_set_Pvoid_t2( x )
        Pvoid_t x
    CODE:
        x = 4;
    OUTPUT:
        x

void
magic_get_Word_t( x )
        Word_t x
    CODE:

Word_t
magic_set_Word_t1()
    CODE:
        RETVAL = 6;
     OUTPUT:
        RETVAL

void
magic_set_Word_t2( x )
        Word_t x
    CODE:
        x = 7;
    OUTPUT:
        x

void
magic_get_PWord_t( x )
        Word_t* x
    CODE:

Word_t*
magic_set_PWord_t1()
    CODE:
        RETVAL = 9;
     OUTPUT:
        RETVAL

void
magic_set_PWord_t2( x )
        Word_t* x
    CODE:
        x = 10;
    OUTPUT:
        x

void
magic_get_Str( x )
        Str x
    CODE:
        

Str
magic_set_Str1()
    CODE:
        RETVAL.ptr = "bb\0cc";
        RETVAL.length = 5;
    OUTPUT:
        RETVAL

void
magic_set_Str2( out )
        Str out
    CODE:
        out.ptr = "cc\0dd";
        out.length = 5;
    OUTPUT:
        out

Str
magic_set_Str3()
    CODE:
        RETVAL.ptr = "ee";
        RETVAL.length = 0;
    OUTPUT:
        RETVAL

void
magic_set_Str4( out )
        Str out
    CODE:
        out.ptr = "ff";
        out.length = 0;
    OUTPUT:
        out

.
