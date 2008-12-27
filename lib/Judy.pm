package Judy;

use strict;
use warnings;

BEGIN {
    our $VERSION = '0.09';

    require XSLoader;
    XSLoader::load( __PACKAGE__, $VERSION );
}

use Sub::Exporter -setup => {
    exports => [qw[ PJERR JLAP_INVALID ]]
};

# Load all the interfaces. The XS package already loaded all the real
# implementation anyway. Beware, each implementation also uses
# Judy.pm.
require Judy::1;
require Judy::L;
require Judy::SL;
require Judy::HS;

1;
