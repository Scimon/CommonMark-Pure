use v6;
use Test;
use CommonMark::Pure;
use JSON::Fast;

my $tests = from-json( "t/spec.json".IO.slurp );

for $tests.list -> %test {
    my $got = CommonMark::Pure.to-html( %test{'markdown'} );
    is $got, %test{'html'}, "%test<section> : %test<example> markdown : '{ %test{'markdown'}.subst( /\n/, '\\n', :g )}'"; 
}

done-testing;
