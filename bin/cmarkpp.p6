#!/usr/bin/env perl6

use v6;
use CommonMark::PP6;

multi sub MAIN ( *@files ) {
    for @files -> $file {
	CommonMark::PP6.to-html( $file.IO.slurp ).say;
    }
}

multi sub MAIN () {
    CommonMark::PP6.to-html( $*IN.slurp ).say;
}
