use Perl::Critic;
use Test::More;

my $critic = Perl::Critic->new;
$critic->add_policy(-policy => "Perl::Critic::Policy::Perlsecret");

my @v      = $critic->critique("t/Perlsecret/Perlsecret.run");

ok @v == 2;
like $v[0], qr/Perlsecret/;

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