package Judy;

use strict;
use warnings;

BEGIN {
    our $VERSION = '0.32';

    require Alien::Judy;
    require DynaLoader;

    # Ensure that libJudy is loadable
    if ( ! DynaLoader::dl_findfile('-lJudy') ) {

        # Alien::Judy will have installed it to
        # $Config{sitearch}/Alien/Judy
        local @DynaLoader::dl_library_path = Alien::Judy::lib_dirs();
        my $libJudy_file = DynaLoader::dl_findfile('-lJudy');
        DynaLoader::dl_load_file( $libJudy_file, 0x01 );
    }

    # Now load the Perl wrapper over libJudy
    our @ISA;
    local @ISA = 'DynaLoader';
    Judy->bootstrap;
}

use Sub::Exporter -setup => {
    exports => [qw[ PJERR JLAP_INVALID ]]
};

# Beware, each implementation also uses Judy.pm. Both Judy.pm and 1.pm
# (for example) require() each other. In execution order:
#
# Compile Judy.pm
# iz $INC{'Judy.pm'} true naow?
# Execute Judy.pm
# $INC{'Judy.pm'} iz true naow.
# require 1.pm
# Compile 1.pm
# Execute 1.pm
# require Judy.pm # but $INC{'Judy.pm'} is already true

# Load the functional interfaces. The XS package already loaded all
# the real implementation anyway.
#
require Judy::1;
require Judy::L;
require Judy::SL;
require Judy::HS;

# Load the OO interfaces.
#
require Judy::_obj;

# Load the tie interface.
# 
require Judy::_tie;
Judy::_tie->import;

1;
