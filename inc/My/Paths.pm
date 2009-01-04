package My::Paths;

use strict;
use warnings;

use Config '%Config';
use File::Spec ();
use Cwd 'cwd';

sub unique { my %seen; grep { ! $seen{$_}++ } @_ }

use constant CCINC => [
    map { "-I$_" }
    grep { $_ && -d }
    unique(
	cwd(),
	map { File::Spec->catdir( $_, 'include' ) }
	@Config{qw( siteprefixexp prefixexp )}
    )
    ];

use constant CCLIB => [
    map { "-L$_" }
    grep { $_ && -d }
    unique(
	map { File::Spec->catdir( $_, 'Alien', 'Judy' ) }
	@Config{qw(sitearchexp sitearch)}
    )
    ];

1;

