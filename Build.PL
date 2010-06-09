#!perl
use Module::Build;
BEGIN {
    unshift @INC, 'inc';
}
use Alien::Judy;

my $build = Module::Build->new(
    module_name => 'Judy',
    license => 'perl',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'strict'         => 0,
        'warnings'       => 0,
        'Config'         => 0,
        'vars'           => 0,
        'File::Basename' => 0,
        'File::Spec'     => 0,
        'File::Copy'     => 0,
        'DynaLoader'     => 0,

        'Test::More'         => 0,
        'Test::Deep'         => 0,
	'ExtUtils::CBuilder' => 0,
    },
    requires => {
        'perl'       => '5.6.0',
        'strict'     => 0,
        'warnings'   => 0,
        'DynaLoader' => 0,
        'constant'   => 0,
        'Config'     => 0,

	'Sub::Exporter' => 0,
        'Alien::Judy'   => '0.13',
    },

    create_readme => 1,
    dynamic_config => 1,
    include_dirs => [ Alien::Judy::inc_dirs() ],
    extra_linker_flags => join( ' ',
        (
            map { "-L$_" }
            Alien::Judy::lib_dirs(),
        ),
        '-lJudy'
    ),
);
$build->create_build_script();
