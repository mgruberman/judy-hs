use strict;
use warnings;
use ExtUtils::MakeMaker;
use ExtUtils::Constant 'WriteConstants';

# Render README.pod to README for consumption by the world. README.pod
# is only present in the version available from git.
if ( -e 'README.pod' ) {
    system 'perldoc -t README.pod > README';
}

WriteConstants(
    NAME => 'Judy',
    DEFAULT_TYPE => 'UV',
    NAMES => [qw[JLAP_INVALID PJERR]]
    );

WriteMakefile(
    NAME                => 'Judy::HS',
    AUTHOR              => 'Joshua ben Jore <jjore@cpan.org>',
    VERSION_FROM        => 'lib/Judy/HS.pm',
    ABSTRACT_FROM       => 'lib/Judy/HS.pod',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PREREQ_PM => {
        'Test::More' => 0,
	'Sub::Exporter' => 0,
        'Alien::Judy' => 0,
    },
    LIBS => ['-lJudy'],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Judy-HS-*' },
);
