package Judy;

use strict;
use warnings;
use vars qw( $VERSION @ISA );

$VERSION = '0.37';

require Alien::Judy;
my $av_version = Alien::Judy->VERSION;
if ( $av_version < 0.18 ) {
    die "Alien::Judy version 0.18 required--this is only version $av_version";
}
Alien::Judy::dl_load_libjudy();

# Now load the Perl wrapper over libJudy
local @ISA = 'DynaLoader';
__PACKAGE__->bootstrap;

require Sub::Exporter;
Sub::Exporter->import(
    -setup => {
        exports => [qw[ PJERR JLAP_INVALID ]]
    }
);

# Beware, each implementation also uses Judy.pm. Both Judy.pm and 1.pm
# (for example) require() each other. In execution order:
#
# Compile Judy.pm
# iz $INC{'Judy.pm'} true naow?
# Execute Judy.pm
# $INC{'Judy.pm'} iz true naow.
# require 1.pm
# Compile 1.pm
# Execute 1.pm
# require Judy.pm # but $INC{'Judy.pm'} is already true

# Load the functional interfaces. The XS package already loaded all
# the real implementation anyway.
#
local $Judy::LOADING = 1;

# Load the OO interfaces.
#
require Judy::_obj;

# Load the tie interface.
# 
require Judy::_tie;
Judy::_tie->import;

require Judy::1;
require Judy::L;
require Judy::SL;
require Judy::HS;



1;
