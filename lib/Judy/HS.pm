package Judy::HS;

use strict;
use warnings;

BEGIN {
    our $VERSION = '0.02';

    require XSLoader;
    XSLoader::load(__PACKAGE__,$VERSION);
}

use Sub::Exporter -setup => {
    exports => [qw[ JHSI JHSD JHSG JHSFA ]],
};

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'
