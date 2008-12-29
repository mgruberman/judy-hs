use strict;
use warnings;
use vars '@MAGIC';
use Data::Dumper;

my $magic;

$|=1;
sub X { print Dumper([\@MAGIC,${tied($magic)}]); @MAGIC = () }

{
  tie $magic, 'MAGIC';
  MAGIC::get_Pvoid_t( $magic );
  X;
  $magic = MAGIC::set_Pvoid_t1();
  X;
  MAGIC::get_Pvoid_t( $magic );
  X;
  MAGIC::set_Pvoid_t2( $magic );
  X;
  untie $magic;
}

{
  tie $magic, 'MAGIC';
  $magic = 5;
  @::MAGIC = ();
  MAGIC::get_Word_t( $magic );
  X;
  $magic = MAGIC::set_Word_t1();
  X;
  MAGIC::get_Word_t( $magic );
  X;
  MAGIC::set_Word_t2( $magic );
  X;
  untie $magic;
}

{
  tie $magic, 'MAGIC';
  $magic = 8;
  @::MAGIC = ();
  MAGIC::get_PWord_t( $magic );
  X;
  $magic = MAGIC::set_PWord_t1();
  X;
  MAGIC::set_PWord_t2( $magic );
  X;
  untie $magic;
}

package MAGIC;
sub TIESCALAR {
    my ( $class ) = @_;
    push @::MAGIC, [TIESCALAR => @_];
    bless do { \ my $scalar }, $class;
}
sub FETCH   { push @::MAGIC, [FETCH=>${$_[0]}]; ${$_[0]}         }
sub STORE   { push @::MAGIC, [STORE=>${$_[0]},$_[1]]; ${$_[0]} = $_[1] }
sub UNTIE   { push @::MAGIC, ['UNTIE'];                  }
sub DESTROY { push @::MAGIC, ['DESTROY'];                }

use Inline C => <<'MAGIC', NAME => 'MAGIC', XSMODE => 1, CLEAN_BUILD_AREA => 0, CLEAN_AFTER_BUILD => 0;
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "Judy.h"


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

MAGIC
