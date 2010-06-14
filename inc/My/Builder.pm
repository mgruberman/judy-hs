package My::Builder;

use strict;
use warnings;
use vars qw( @ISA $LIB_EXT );
use Config ();
use File::Spec;

use Module::Build;
@ISA = 'Module::Build';

$LIB_EXT = $Config::Config{lib_ext};

sub ACTION_build {
    my ( $self, @args ) = @_;

    # Update include_dirs and extra_linker_flags to find the Judy.h
    # that's come while provided by installing Alien::Judy
    #
    # TODO: This updating violates the Module::Build API.
    my @all_dirs = (
        '.',
        (
            map { File::Spec->catdir( $_, 'Alien', 'Judy' ) }
            @Config::Config{qw( sitearchexp sitearch )},
            @INC
        )
        );

    $self->{properties}{include_dirs} = [
        grep {
               -e File::Spec->catfile( $_, 'Judy.h' )
            || -e File::Spec->catfile( $_, 'pjudy.h' )
            || -e File::Spec->catfile( $_, 'ppport.h' )
        }
        @all_dirs
    ];
    $self->{properties}{extra_linker_flags} = [
        (
            map { "-L$_" }
            grep { -e File::Spec->catfile( $_, "libJudy$LIB_EXT" ) }
            map { File::Spec->catdir( $_, 'Alien', 'Judy' ) }
            @Config::Config{qw( sitearchexp sitearch )},
            @INC
        ),
        '-lJudy',
    ];

    return $self->SUPER::ACTION_build( @args );
}

1;
