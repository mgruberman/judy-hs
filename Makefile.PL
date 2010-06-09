use strict;
use warnings;
use ExtUtils::MakeMaker;
use lib 'inc';
use Alien::Judy;

# Render README.pod to README for consumption by the world. README.pod
# is only present in the version available from git.
if ( -e 'README.pod' ) {
    system 'perldoc -t README.pod > README';
}

WriteMakefile(
    NAME                => 'Judy',
    AUTHOR              => 'Joshua ben Jore <jjore@cpan.org>',
    VERSION_FROM        => 'lib/Judy.pm',
    ABSTRACT_FROM       => 'lib/Judy.pod',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    INC => join( ' ',
        map { "-I$_" }
        Alien::Judy::inc_dirs()
    ),
    PREREQ_PM => {
        'Test::More' => 0,
        'Test::Deep' => 0,
	'Sub::Exporter' => 0,
	'ExtUtils::CBuilder' => 0,
        'Inline::C' => 0, # for testing
        'Alien::Judy' => '0.09',
    },
    OPTIMIZE => '-g',
    LIBS => [
        join( ' ',
            (
                map { "-L$_" }
                Alien::Judy::lib_dirs(),
            ),
            '-lJudy'
        )
    ],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Judy-*' },
);
