package Judy::HS;

use strict;
use warnings;

BEGIN {
    our $VERSION = '0.03';

    require XSLoader;
    XSLoader::load(__PACKAGE__,$VERSION);
}

use Sub::Exporter -setup => {
    exports => [qw[ Duplicates Set Delete Get Free ]],
};

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'
