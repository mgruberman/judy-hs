package Judy;

use strict;
use warnings;

BEGIN {
    our $VERSION = '0.26';

    require XSLoader;
    XSLoader::load( __PACKAGE__, $VERSION );
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
