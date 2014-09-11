package Perl::Critic::Policy::Perlsecret;

use 5.006001;
use strict;
use warnings;

use base 'Perl::Critic::Policy';

use Carp;
use Perl::Critic::Utils;

=head1 NAME

Perl::Critic::Policy::Perlsecret - Prevent Perlsecret operators and constants.


=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.3';

=head1 AFFILIATION

This is a standalone policy not part of a larger PerlCritic Policies group.


=head1 DESCRIPTION

Prevents Perlsecrets appearing in your codebase.

=head1 CONFIGURATION

...

=head1 LIMITATIONS

Probably many...

=cut

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

=head1 BUGS

Please report any bugs or feature requests through the web interface at
L<https://github.com/lancew/Perl-Critic-Policy-Perlsecret/issues>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Perl::Critic::Policy::Perlsecret


You can also look for information at:

=over 4

=item * GitHub (report bugs there)

L<https://github.com/lancew/Perl-Critic-Policy-Perlsecret/issues>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Perl-Critic-Policy-Perlsecret>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Perl-Critic-Policy-Perlsecret>

=item * MetaCPAN

L<https://metacpan.org/release/Perl-Critic-Policy-Perlsecret>

=back


=head1 AUTHOR

L<Lance Wicks|https://metacpan.org/author/LANCEW>,
C<< <lancew at cpan.org> >>.


=head1 COPYRIGHT & LICENSE

Copyright 2014 Lance Wicks.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License version 3 as published by the Free
Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see http://www.gnu.org/licenses/

=cut

1;
