package Judy::Mem;

use strict;
use warnings;

use Judy::HS ();

use Sub::Exporter -setup => {
    exports => [qw[
        PeekU PokeU
        PeekI PokeI
        String2Ptr Free
        Ptr2String Ptr2String2
    ]],
};

no warnings;
'Warning! The consumption of alcohol may cause you to think you have mystical kung-fu powers.'
