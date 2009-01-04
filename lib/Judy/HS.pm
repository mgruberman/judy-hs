package Judy::HS;

use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [qw[ Duplicates Set Delete Get Free ]],
};

require Judy; # Beware, Judy.pm also loads Judy::HS.

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'
