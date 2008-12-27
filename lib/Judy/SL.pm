package Judy::SL;

use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [qw[
        Set Delete Get Free
        First Next Last Prev
    ]],
};

require Judy; # Beware, Judy.pm also loads Judy::SL.

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'
