use strict;
use warnings;
use Test::More;
use Perl::Critic::TestUtils qw( pcritique );


my $code = <<'__CODE__';
    print 0+ '23a';
}
__CODE__

is pcritique('Perlsecret', \$code), 1;

$code = <<'__CODE__';
for ( @{[ qw( 1 2 3 ) ]} ) {
    $_ = $_ * $_;    # contrived
    print "square: $_\n";
}
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