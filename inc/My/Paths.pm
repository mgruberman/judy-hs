package My::Paths;

use strict;
use warnings;

use Alien::Judy ();

use constant CCINC => [
    map { "-I$_" }
    grep { $_ && -d }
    Alien::Judy::inc_dirs()
];

use constant CCLIB => [
    map { "-L$_" }
    grep { $_ && -d }
    Alien::Judy::lib_dirs()
];

1;

