package Judy::SL;

use strict;
use warnings;

use Judy::HS ();

use Sub::Exporter -setup => {
    exports => [qw[
        Set Delete Get Free
        First Next Last Prev
    ]],
};

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'
