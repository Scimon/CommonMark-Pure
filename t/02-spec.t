use v6;
use Test;
use CommonMark::Pure;
use JSON::Fast;


sub MAIN() {
    my $count = 0;
    my $tests = from-json( "t/spec.json".IO.slurp );
    my $id = %*ENV<SPEC_TEST_ID> // False;

    for $tests.list -> %test {
        $count++;
        next if $id && $id != $count;
        my $got = CommonMark::Pure.to-html( %test{'markdown'} );
        is $got, %test{'html'}, "%test<section> : %test<example> markdown : '{ %test{'markdown'}.subst( /\n/, '\\n', :g )}'";
        CATCH {
            default {
                flunk "%test<section> : %test<example> markdown : '{ %test{'markdown'}.subst( /\n/, '\\n', :g )}'";
            }
        }
    }

    done-testing;
}
