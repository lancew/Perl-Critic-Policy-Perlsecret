package Perl::Critic::Policy::Perlsecret;
# ABSTRACT: Prevent perlsecrets entering your codebase
=pod

=encoding UTF-8

=head1 NAME

Perl::Critic::Policy::Perlsecret - Prevent perlsecrets entering your codebase

=cut

use 5.006001;
use strict;
use warnings;

use parent 'Perl::Critic::Policy';

use Carp;
use Perl::Critic::Utils;


our $VERSION = '0.0.5';

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
        'Venus'     => \&_venus,
        'Baby Cart' => \&_baby_cart,
        'Bang Bang' => \&_bang_bang,
        'Inchworm'  => \&_inchworm,
        'Inchworm on a stick'         => \&_inchworm_on_a_stick,
        'Space Station'               => \&_space_station,
        'Goatse'                      => \&_goatse,
        'Flaming X-Wing'              => \&_flaming_x_wing,
        'Kite'                        => \&_kite,
        'Ornate Double Edged Sword'   => \&_ornate_double_edged_sword,
        'Flathead'                    => \&_flathead,
        'Phillips'                    => \&_phillips,
        'Torx'                        => \&_torx,
        'Pozidriv'                    => \&_pozidriv,
        'Winking fat comma'           => \&_winking_fat_comma,
#        'Enterprise'                  => qr/\(.*\)x!!/,
#        'Key of truth'                => qr/0\+!!/,
#        'Abbott and Costello'         => qr/\|\|\(\)/,
#        'Leaning Abbott and Costello' => qr/\/\/\(\)/,
    );

    for my $policy ( keys %violations ) {
        if ( $violations{$policy}->($element) ) {
            return $self->violation( $DESCRIPTION . " $policy ",
                $EXPLANATION, $element );
        }
    }

    return;    # No matches return i.e. no violations
}

sub _venus {
    for my $child ($_[0]->children)
    {
        next unless ref($child) eq 'PPI::Token::Operator';

        return 1 if $child->previous_sibling eq '0';
        return 1 if $child->next_sibling eq '0';
    }
}

sub _baby_cart {
    for my $child ($_[0]->children)
    {
        if (ref($child) eq 'PPI::Token::Cast' ) {
            return 1 if $child->snext_sibling =~ m/\{\s*?\[/;
        }
        if (ref($child) eq 'PPI::Token::Quote::Double') {
            return 1 if $child =~ m/@\{\s*?\[/;
        };

    }
}

sub _bang_bang {
    for my $child ($_[0]->children)
    {
        next unless ref($child) eq 'PPI::Token::Operator';
        return 1 if $child eq '!' && $child->snext_sibling eq '!';
    }
}

sub _inchworm {
    for my $child ($_[0]->children)
    {
        next unless ref($child) eq 'PPI::Token::Operator';
        return 1 if $child eq '~~';
        return 1 if $child eq '~' && $child->snext_sibling eq '~';
    }
}

sub _inchworm_on_a_stick {
    for my $child ($_[0]->children)
    {
        next unless ref($child) eq 'PPI::Token::Operator';

        return 1 if $child eq '~' && $child->snext_sibling eq '-';
        return 1 if $child eq '-' && $child->snext_sibling eq '~';
    }
}

sub _space_station {
    for my $child ($_[0]->children)
    {
        next unless ref($child) eq 'PPI::Token::Operator';

        return 1 if $child eq '-' 
                 && $child->snext_sibling eq '+' 
                 && $child->snext_sibling->snext_sibling eq '-';
    }
}

sub _goatse {
    for my $child ($_[0]->children)
    {
        next unless ref($child) eq 'PPI::Structure::List';
        return 1 if $child->sprevious_sibling eq '=' && $child->snext_sibling eq '=';
    }
}

sub _flaming_x_wing {
    for my $child ($_[0]->children)
    {

        next unless ref($child) eq 'PPI::Token::QuoteLike::Readline';
        return 1 if $child->sprevious_sibling eq '='
                 && $child->snext_sibling eq '=~';
    }
}

sub _kite {
    for my $child ($_[0]->children)
    {
        next unless ref($child) eq 'PPI::Token::Operator';
        return 1 if $child eq '~~'
                 && $child->snext_sibling eq '<>';
    }
}

sub _ornate_double_edged_sword {
    for my $child ($_[0]->children)
    {
        next unless $child eq '<<m';
        return 1 if $child->snext_sibling eq '=~'
                 && $child->snext_sibling->snext_sibling eq 'm>>';
    }
}

sub _flathead {
    for my $child ($_[0]->children)
    {
        next unless $child eq '-=';
        return 1 if $child->snext_sibling eq '!';
    }
}

sub _phillips {
    for my $child ($_[0]->children)
    {
        next unless $child eq '+=';
        return 1 if $child->snext_sibling eq '!';
    }
}

sub _torx {
    for my $child ($_[0]->children)
    {
        next unless $child eq '*=';
        return 1 if $child->snext_sibling eq '!';
    }
}

sub _pozidriv {
    for my $child ($_[0]->children)
    {
        next unless $child eq 'x=';
        return 1 if $child->snext_sibling eq '!';
    }
}

sub _winking_fat_comma {
    for my $child ($_[0]->children)
    {
        next unless ref($child) eq 'PPI::Token::Operator'
                     && $child  eq ',';
        return 1 if $child->snext_sibling eq '=>';
    }
}
1;
