use strict;
use warnings;
use Test::More;
use Perl::Critic::TestUtils qw( pcritique );


# Venus
my $code = <<'__CODE__';
    print 0+ '23a';
}
__CODE__
is pcritique('Perlsecret', \$code), 1;

# Babycart
$code = <<'__CODE__';
for ( @{[ qw( 1 2 3 ) ]} ) { return $_ }
__CODE__
is pcritique('Perlsecret', \$code), 2;

# Bang Bang
$code = <<'__CODE__';
my $true  = !! 'a string';   # now 1
__CODE__
is pcritique('Perlsecret', \$code), 1;

# Eskimo Greeting - SKipped as only used in one liners

# Inch worm
$code = <<'__CODE__';
$x = 1.23;
print ~~$x;
__CODE__
is pcritique('Perlsecret', \$code), 1;

# Inch worm on a stick
$code = <<'__CODE__';
$y = ~-$x * 4;
$y = -~$x * 4;
__CODE__
is pcritique('Perlsecret', \$code), 2;

# Space Station
$code = <<'__CODE__';
print -+- '23a';
__CODE__
is pcritique('Perlsecret', \$code), 1;

# Goatse
$code = <<'__CODE__';
$n =()= "abababab" =~ /a/;
$n =($b)= "abababab" =~ /a/g;
__CODE__
is pcritique('Perlsecret', \$code), 2;

# Flaming X-Wing
$code = <<'__CODE__';
@data{@fields} =<>=~ $regexp;
__CODE__
is pcritique('Perlsecret', \$code), 1;

done_testing;


=pod

Operator     Nickname                     Function
======================================================
0+           Venus                        numification
@{[ ]}       Babycart                     list interpolation
!!           Bang bang                    boolean conversion
}{           Eskimo greeting              END block for one-liners
~~           Inchworm                     scalar
~-           Inchworm on a stick          high-precedence decrement
-~           Inchworm on a stick          high-precedence increment
-+-          Space station                high-precedence numification
=( )=        Goatse                       scalar / list context
=< >=~       Flaming X-Wing               match input, assign captures
~~<>         Kite                         a single line of input
<<m=~m>> m ; Ornate double-bladed sword   multiline comment
-=!   -=!!   Flathead                     conditional decrement
+=!   +=!!   Phillips                     conditional increment
x=!   x=!!   Pozidriv                     conditional reset to ''
*=!   *=!!   Torx                         conditional reset to 0
,=>          Winking fat comma            non-stringifying fat comma
()x!!        Enterprise                   boolean list squash
0+!!         Key to the truth             numeric boolean conversion
||()         Abbott and Costello          remove false scalar from list
//()         Leaning Abbott and Costello  remove undef from list

=cut