use strict;
use warnings;
use Test::More;
use Perl::Critic::TestUtils qw( pcritique );

my $code = <<'__CODE__';
    print 0+ '23a';
}
__CODE__

is pcritique('Perlsecret', \$code), 1;

done_testing;
