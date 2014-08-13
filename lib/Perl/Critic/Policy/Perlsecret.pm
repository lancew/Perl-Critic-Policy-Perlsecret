package Perl::Critic::Policy::Perlsecret;

use 5.006001;
use strict;
use warnings;

use base 'Perl::Critic::Policy';

use Carp;
use Data::Dumper;
use Perl::Critic::Utils;
use Readonly;
use String::InterpolatedVariables;
use Try::Tiny;


=head1 NAME

Perl::Critic::Policy::Perlsecret - Prevent Perlsecret operators and constants.


=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.1';


=head1 AFFILIATION

This is a standalone policy not part of a larger PerlCritic Policies group.


=head1 DESCRIPTION

Prevents Persecrets appearing in your codebase.

=head1 CONFIGURATION

...

=head1 LIMITATIONS

Probably many...

=cut

Readonly::Scalar my $DESCRIPTION => 'Perlsecret risk.';
Readonly::Scalar my $EXPLANATION => 'Perlsecret detected: %s';

# Default for the name of the methods that make a variable safe to use in SQL
# strings.
Readonly::Scalar my $QUOTING_METHODS_DEFAULT => q|
	quote_identifier
	quote
|;

# Default for the name of the packages and functions / class methods that are safe to
# concatenate to SQL strings.
Readonly::Scalar my $SAFE_FUNCTIONS_DEFAULT => q|
|;

# Regex to detect comments like ## SQL safe ($var1, $var2).
Readonly::Scalar my $SQL_SAFE_COMMENTS_REGEX => qr/
	\A
	(?: [#]! .*? )?
	\s*
	# Find the ## annotation starter.
	[#][#]
	\s*
	# "SQL safe" is our keyword.
	SQL \s+ safe
	\s*
	# List of safe variables between parentheses.
	\(\s*(.*?)\s*\)
/ixms;


=head1 FUNCTIONS

=head2 supported_parameters()

Return an array with information about the parameters supported.

	my @supported_parameters = $policy->supported_parameters();

=cut

sub supported_parameters
{
	return (
		{
			name            => 'quoting_methods',
			description     => 'A space-separated string listing the methods that return a safely quoted value.',
			default_string  => $QUOTING_METHODS_DEFAULT,
			behavior        => 'string',
		},
		{
			name            => 'safe_functions',
			description     => 'A space-separated string listing the functions that return a safely quoted value',
			default_string  => $SAFE_FUNCTIONS_DEFAULT,
			behavior        => 'string',
		},
	);
}


=head2 default_severity()

Return the default severify for this policy.

	my $default_severity = $policy->default_severity();

=cut

sub default_severity
{
	return $Perl::Critic::Utils::SEVERITY_HIGHEST;
}


=head2 default_themes()

Return the default themes this policy is included in.

	my $default_themes = $policy->default_themes();

=cut

sub default_themes
{
	return qw( security );
}


=head2 applies_to()

Return the class of elements this policy applies to.

	my $class = $policy->applies_to();

=cut

sub applies_to
{
	return qw(
		PPI::Token::Quote
		PPI::Token::HereDoc
	);
}


=head2 violates()

Check an element for violations against this policy.

	my $policy->violates(
		$element,
		$document,
	);

=cut

sub violates
{
	my ( $self, $element, $doc ) = @_;

	parse_config_parameters( $self );

	parse_comments( $self, $doc );

	# Make sure the first string looks like a SQL statement before investigating
	# further.
	return ()
		if !is_sql_statement( $element );

	# Find SQL injection vulnerabilities.
	my $sql_injections = detect_sql_injections( $self, $element );

	# Return violations if any.
	return defined( $sql_injections ) && scalar( @$sql_injections ) != 0
		? $self->violation(
			$DESCRIPTION,
			sprintf(
				$EXPLANATION,
				join( ', ', @$sql_injections ),
			),
			$element,
		)
		: ();
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
