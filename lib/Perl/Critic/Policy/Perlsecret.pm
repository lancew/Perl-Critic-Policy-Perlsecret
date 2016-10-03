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
use List::Util 'first';

our $VERSION = '0.0.5';

Readonly::Scalar my $DESCRIPTION => 'Perlsecret risk.';
Readonly::Scalar my $EXPLANATION => 'Perlsecret detected: %s';

# Eskimo Greeting skipped as only used in one liners
Readonly::Hash my %default_violations => (
    'Venus'                       => \&_venus,
    'Baby Cart'                   => \&_baby_cart,
    'Bang Bang'                   => \&_bang_bang,
    'Inchworm'                    => \&_inchworm,
    'Inchworm on a Stick'         => \&_inchworm_on_a_stick,
    'Space Station'               => \&_space_station,
    'Goatse'                      => \&_goatse,
    'Flaming X-Wing'              => \&_flaming_x_wing,
    'Kite'                        => \&_kite,
    'Ornate Double Edged Sword'   => \&_ornate_double_edged_sword,
    'Flathead'                    => \&_flathead,
    'Phillips'                    => \&_phillips,
    'Torx'                        => \&_torx,
    'Pozidriv'                    => \&_pozidriv,
    'Winking Fat Comma'           => \&_winking_fat_comma,
    'Enterprise'                  => \&_enterprise,
    'Key of Truth'                => \&_key_of_truth,
    'Abbott and Costello'         => \&_abbott_and_costello,
);

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

sub supported_parameters {
    return (
        {
            name           => 'allow_secrets',
            description    => q<A list of perlsecrets to allow.>,
            default_string => '',
        },

        {
            name           => 'disallow_secrets',
            description    => q<A list of perlsecrets to disallow (default: all perlsecrets).>,
            default_string =>
                'Venus, Baby Cart, Bang Bang, Inchworm, Inchworm on a Stick, ' .
                'Space Station, Goatse, Flaming X-Wing, Kite, '                .
                'Ornate Double Edged Sword, Flathead, Phillips, Torx, '        .
                'Pozidriv, Winking Fat Comma, Enterprise, Key of Truth, '      .
                'Abbott and Costello',
        },
    );
}

my $SPLIT_RE = qr/\s*,\s*/;

sub read_config_list {
    my ( $self, $str ) = @_;

    my @values = map {
        ( my $new = $_ ) =~ s/^\s+|\s+$//;
        $new;
    } split $SPLIT_RE, $str;

    return @values;
}

sub violates {
    my ( $self, $element, $doc ) = @_;

    my @disallowed = $self->read_config_list(
        $self->{'_disallow_secrets'}
    );

    my @allowed = $self->read_config_list(
        $self->{'_allow_secrets'}
    );

    my %violations = %default_violations;
    foreach my $secret (@disallowed) {
        if ( ! exists $default_violations{$secret} ) {
            croak("$secret is not a known secret");
        }

        first { $secret eq $_ } @allowed
            and delete $violations{$secret};
    }

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
sub _enterprise {
    for my $child ($_[0]->children)
    {
        next unless $child->class eq 'PPI::Structure::List';
        return 1 if $child->snext_sibling eq 'x'
        && $child->snext_sibling->snext_sibling eq '!'
        && $child->snext_sibling->snext_sibling->snext_sibling eq '!'
    }
}

sub _key_of_truth {
    for my $child ($_[0]->children)
    {
        next unless $child->class eq 'PPI::Token::Number';
        return 1 if $child eq '0'
                 && $child->snext_sibling eq '+'
                 && $child->snext_sibling->snext_sibling eq '!'
                 && $child->snext_sibling->snext_sibling->snext_sibling eq '!'
    }
}

sub _abbott_and_costello {
    for my $child ($_[0]->children)
    {
        next unless ref($child) eq 'PPI::Token::Operator';

        return 1 if ($child eq '||' || $child eq '//')
                && $child->snext_sibling->class eq 'PPI::Structure::List';
    }
}

1;
