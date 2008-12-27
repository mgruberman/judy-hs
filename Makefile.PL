use strict;
use warnings;
use ExtUtils::MakeMaker;
use ExtUtils::Constant 'WriteConstants';
use File::Spec ();
use Config '%Config';

# Render README.pod to README for consumption by the world. README.pod
# is only present in the version available from git.
if ( -e 'README.pod' ) {
    system 'perldoc -t README.pod > README';
}

WriteConstants(
    NAME => 'Judy',
    NAMES => [qw[JLAP_INVALID PJERR]]
    );

sub unique { my %seen; grep { ! $seen{$_}++ } @_ }

my @inc = unique(
    map { join '', '-I', File::Spec->catdir( $_, 'include' ) }
    @Config{qw( siteprefixexp prefixexp )}
    );

my @lib = unique(
    map { join '', '-L', File::Spec->catdir( $_, 'Alien', 'Judy' ) }
    @Config{qw(sitearchexp sitearch)}
    );

WriteMakefile(
    NAME                => 'Judy',
    AUTHOR              => 'Joshua ben Jore <jjore@cpan.org>',
    VERSION_FROM        => 'lib/Judy.pm',
    ABSTRACT_FROM       => 'lib/Judy.pod',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    INC => "@inc",
    PREREQ_PM => {
        'Test::More' => 0,
	'Sub::Exporter' => 0,
	'ExtUtils::CBuilder' => 0,
        'Alien::Judy' => '0.06',
    },
    LIBS => ["@lib -lJudy"],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Judy-*' },
);
