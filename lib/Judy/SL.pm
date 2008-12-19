package Judy::SL;

use strict;
use warnings;

BEGIN {
    our $VERSION = '0.01';

    require XSLoader;
    XSLoader::load(__PACKAGE__,$VERSION);
}

use Sub::Exporter -setup => {
    exports => [qw[ Set Delete Get Free SearchForward SearchForwardExclusive SearchBackwards SearchBackwardsExclusive ]],
};

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'
