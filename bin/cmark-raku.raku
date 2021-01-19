#!/usr/bin/env raku

use v6;
use CommonMark::Pure;

multi sub MAIN ( *@files ) {
    for @files -> $file {
	CommonMark::Pure.to-html( $file.IO.slurp ).say;
    }
}

multi sub MAIN () {
    CommonMark::Pure.to-html( $*IN.slurp ).say;
}
