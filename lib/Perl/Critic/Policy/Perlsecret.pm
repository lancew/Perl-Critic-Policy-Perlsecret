package Perl::Critic::Policy::Perlsecret;
# ABSTRACT: Prevent perlsecrets entering your codebase

use 5.006001;
use strict;
use warnings;

use base 'Perl::Critic::Policy';

use Carp;
use Perl::Critic::Utils;


our $VERSION = '0.0.3';

Readonly::Scalar my $DESCRIPTION => 'Perlsecret risk.';
Readonly::Scalar my $EXPLANATION => 'Perlsecret detected: %s';

sub default_severity {
    return $Perl::Critic::Utils::SEVERITY_HIGHEST;
}

sub default_themes {
    return qw( perlsecret );
}

sub applies_to {
    return qw(
      PPI::Statement
    );
}

sub violates {
    my ( $self, $element, $doc ) = @_;

    # Eskimo Greeting skipped as only used in one liners
    my %violations = (
        'Venus'     => qr/\s0\+\s/,        #\b so it does not match K.O.T.
        'Baby Cart' => qr/\@\{\[.*\]\}/,
        'Bang Bang' => qr/!!/,
        'Inchworm'  => qr/~~/,
        'Inchworm on a stick'         => qr/~-|-~/,
        'Space Station'               => qr/-\+-/,
        'Goatse'                      => qr/=\(.*\)=/,
        'Flaming X-Wing'              => qr/=<.*>=~/,
        'Kite'                        => qr/~~<>/,
        'Ornate Double Edged Sword'   => qr/<<m=~m>>/,
        'Flathead'                    => qr/-=!!|-=!/,
        'Phillips'                    => qr/\+=!!|\+=!/,
        'Torx'                        => qr/\*=!!|\*=!/,
        'Pozidriv'                    => qr/x=!!|x=!/,
        'Winking fat comma'           => qr/,=>/,
        'Enterprise'                  => qr/\(.*\)x!!/,
        'Key of truth'                => qr/0\+!!/,
        'Abbott and Costello'         => qr/\|\|\(\)/,
        'Leaning Abbott and Costello' => qr/\/\/\(\)/,
    );

    for my $policy ( keys %violations ) {
        if ( $element =~ $violations{$policy} ) {
            return $self->violation( $DESCRIPTION . " $policy ",
                $EXPLANATION, $element );
        }
    }

    return;    # No matches return i.e. no violations
}

1;