package Judy::1;

use strict;
use warnings;

use Judy::HS ();

use Sub::Exporter -setup => {
    exports => [qw[
        Set Get Delete Unset Test
        Count Nth
        Free MemUsed
        First Next Last Prev
        FirstEmpty NextEmpty LastEmpty PrevEmpty
    ]],
};

BEGIN {
    *Delete = \&Unset;
    *Get = \&Test;
}

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'
