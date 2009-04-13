package Judy::_obj;

use strict;
use warnings;

# Object accessors
use constant _ptr      => 0;
use constant _ptrptr   => 1;
use constant _type     => 2;
use constant _fulltype => 3;
use constant _innerobj => 4;

use constant NULL => 0x0;

use constant _impl => [qw[ _ptr _ptrptr _type _fulltype _innerobj NULL ptr setptr ]];
use Sub::Exporter -setup => {
    groups => {
        impl => _impl,
    },
    exports => _impl
};

# 0 for the types and 1, L, '' for the types SL and HS.
#
sub first_key;

sub DESTROY {}

sub setptr {
    for ( $_[0] ) {
        if ( $_->[_ptrptr] ) {
            Judy::Mem::Poke( $_->[_ptrptr], $_[1] );
            $_->[_ptr] = $_[1];
            return $_[1];
        }
        else {
            return $_->[_ptr] = $_[1];
        }
    }
}

sub ptr {
    for ( $_[0] ) {
        
        # Sanity check.
        #
        if ( $_->[_ptr] && $_->[_ptrptr] ) {
            my $a = Judy::Mem::Peek($_->[_ptrptr]);
            my $b = $_->[_ptr];
            if ( $a != $b ) {
                Carp::confess( "\*$a != $b" );
            }
        }
        
        if ( $_->[_ptr] ) {
            return $_->[_ptr];
        }
        elsif ( $_->[_ptrptr] ) {
            return $_->[_ptr] = Judy::Mem::Peek( $_->[_ptrptr] );
        }
        else {
            return NULL;
        }
    }
}


1;
