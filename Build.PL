use 5.006;
use strict;
use warnings;

use Module::Build;


my $class = Module::Build->subclass(
	code =>
	q|
		# Override 'test' to support running extended tests in the xt/
		# directory.
		sub ACTION_test
		{
			my ( $self ) = @_;

			$self->recursive_test_files(1);

			$self->test_files( 't', 'xt' )
				if $ENV{'RELEASE_TESTING'};

			return $self->SUPER::ACTION_test();
		}

		# Force running extended tests when testing the distribution.
		sub ACTION_disttest
		{
			my ( $self ) = @_;

			local $ENV{ RELEASE_TESTING } = 1;

			return $self->SUPER::ACTION_disttest();
		}
	|,
);

my $builder = $class->new(
	module_name          => 'Perl::Critic::Policy::Perlsecret',
	license              => 'GPL_3',
	dist_author          => q{Lance Wicks <lancew@cpan.org>},
	dist_version_from    => 'lib/Perl/Critic/Policy/Perlsecret.pm',
	build_requires       =>
	{
		'File::Spec'                    => 0,
		'Test::Deep'                    => 0,
		'Test::FailWarnings'            => 0,
		'Test::More'                    => 0,
		'Test::Perl::Critic::Policy'    => 0,
	},
	requires             =>
	{
		'perl'                          => 5.006,
		'Carp'                          => 0,
		'Perl::Critic::Policy'          => 0,
		'Perl::Critic::Utils'           => 0,
	},
	add_to_cleanup       =>
	[
		'Perl-Critic-Policy-Perlsecret-*',
	],
	create_makefile_pl   => 'traditional',
	recursive_test_files => 1,
	configure_requires   =>
	{
		'Module::Build'        => 0,
	},
	meta_merge           =>
	{
		resources              =>
		{
			repository  => 'https://github.com/lancew/Perl-Critic-Policy-Perlsecret',
			homepage    => 'https://metacpan.org/release/Perl-Critic-Policy-Perlsecret',
			bugtracker  => 'https://github.com/lancew/Perl-Critic-Policy-Perlsecret/issues',
		},
	},
);

$builder->create_build_script();
