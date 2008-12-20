package Judy::Mem;

use strict;
use warnings;

use Judy::HS ();

use Sub::Exporter -setup => {
    exports => [qw[
        Peek Poke
        Copy Free
    ]],
};

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'
