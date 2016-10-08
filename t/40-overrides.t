#!perl -T

use strict;
use warnings;

use Test::FailWarnings -allow_deps => 1;
use Test::More tests               => 3;
use Test::Fatal 'dies_ok';
use Perl::Critic::Policy::Perlsecret;
use Perl::Critic::TestUtils qw( pcritique );

my $policy = Perl::Critic::Policy::Perlsecret->new(
    allow_secrets    => 'Venus',
    disallow_secrets => 'Baby Cart',
);

my @parameters = $policy->supported_parameters();

is_deeply \@parameters,
    [
    {   'name'           => 'allow_secrets',
        'default_string' => '',
        'description'    => 'A list of perlsecrets to allow.'
    },
    {   'description' =>
            'A list of perlsecrets to disallow (default: all perlsecrets).',
        'name' => 'disallow_secrets',
        'default_string' =>
            'Venus, Baby Cart, Bang Bang, Inchworm, Inchworm on a Stick, Space Station, Goatse, Flaming X-Wing, Kite, Ornate Double Edged Sword, Flathead, Phillips, Torx, Pozidriv, Winking Fat Comma, Enterprise, Key of Truth, Abbott and Costello'
    }
    ];

# Venus
my $code = <<'__CODE__';
	    print 0+ '23a';
	    #print +0 '23a'; should not be detected as is a comment
	    print +0 '23a';
	}
__CODE__
is pcritique( 'Perlsecret', \$code, { allow_secrets => 'Venus' } ), 0,
    '0 x Venus expected, as Venus allowed';

dies_ok { pcritique( 'Perlsecret', \$code, { disallow_secrets => 'no_chance' } ) }
    'Croaks if invalid disallow_secrets set';
