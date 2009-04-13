package Judy;

use strict;
use warnings;

use Judy::_obj -impl;

sub TIEHASH {
    my $args = $_[2];

    # Allow spaces and such in the spec but remove them prior to use.
    # Normal specs look like: 'Judy::1' or 'Judy::L -> Judy::1'
    #
    my $fulltype = $_[1];
    $fulltype =~ s/[(\s)]+//g;

    # Detect whether this is a simple object or not.
    #
    if ( -1 == index $fulltype, '->' ) {

        # Allow '1' instead of 'Judy::1'
        #
        if ( -1 == index $fulltype, ':' ) {
            $fulltype = "Judy::$fulltype";
        }

        # Return a non-Judy object. No need to get extra re-dispatching
        #
        return $fulltype->TIEHASH( $args ? $args : () );
    }
    else {
        # Tie a simple, non-Judy array internally.
        #
        my ( $type ) = $fulltype =~ /^([\w:']+)/
            or die;

        # Allow '1' instead of 'Judy::1'
        #
        if ( -1 == index $fulltype, ':' ) {
            $fulltype = "Judy::$fulltype";
        }

        my @self;
        $self[_innerobj] = $type->TIEHASH( $args ? $args : () );

        # Store the complete type: Judy::SL->Judy::SL->...
        #
        $self[_fulltype]  = $fulltype;
        $self[_type]      = $type;

        return bless \ @self, 'Judy';
    }
}

sub FETCH {
    for ( $_[0][_innerobj] ) {
        
        # Fetch the next hash.
        #
        my ( $pval, $val) = $_->get( $_[1] );
        
        # Autovivify the current hash. This is more eager than normal perl.
        #
        if ( ! $pval ) {
            my $optr = $_->ptr;
            $pval = $_->set( $_[1], NULL );
            
            my $ptr = $_->ptr;
            
            if ( $optr != $ptr ) {
                $_->setptr( $ptr );
            }
        }
        
        # Return the desired thing. Let Judy decide whether it wants to delegate or not.
        #
        tie my(%h), Judy => $_[0][_type], { ptrptr => $pval };
        return \ %h;
    }
}

sub STORE {
    for ( $_[0][_innerobj] ) {

        # Fetch the current hash to detect orphans.
        #
        my ( $pval, $val ) = $_->get( $_[1] );
        if ( $val ) {
            warn( sprintf "Orphaning %s(0x%x)", $_[0][_type], $val );
        }
        
        # Store the new pointer.
        #
        my $storeobj = %{ $_[2] };
        my $storeptr = $storeobj->ptr;
        if ( $pval ) {
            Judy::Mem::Poke( $pval, $storeptr );
        }
        else {
            my $optr = $_->ptr;
            $pval = $_->set( $_[1], $storeptr );
            my $ptr = $_->ptr;
            if ( $ptr != $optr ) {
                $_->setptr($ptr);
            }
        }
        
        # Return the stored thingy.
        #
        if ( defined wantarray ) {
            tie my(%h), Judy => $_[0][_type], { ptrptr => $pval };
            return \%h;
        }
    }
}

sub EXISTS {
    my ( $pval ) = $_[0][_innerobj]->get( $_[1] );
    return defined $pval;
}

sub FIRSTKEY {
    my ( undef, undef, $key ) = $_[0][_innerobj]->first;
    return $key;
}

sub NEXTKEY {
    my ( undef, undef, $key ) = $_[0][_innerobj]->next( $_[1] );
    return $key;
}

sub DELETE {
    my ( undef, $val ) = $_[0][_innerobj]->delete( $_[1] );
    return defined $val ? $val : ();
}

sub CLEAR {
    for ( $_[0][_innerobj] ) {
        $_->free;
        my $ptr = $_->ptr;
        $_->setptr( $ptr );

        return;
    }
}

sub SCALAR {
    Carp::confess('not implemented');
}

sub UNTIE {
}

sub DESTROY {
}

1;
