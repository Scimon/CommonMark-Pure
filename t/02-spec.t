use v6;
use Test;
use CommonMark::PP6;
use JSON::Fast;

my $tests = from-json( "t/spec.json".IO.slurp );

for $tests.list -> %test {
    note %test.perl;
    my $got = CommonMark::PP6.to-html( %test{'markdown'} );
    is $got, %test{'html'}, "%test<section> : %test<example>"; 
}

done-testing;
