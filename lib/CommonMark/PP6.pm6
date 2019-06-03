use v6;

unit class CommonMark::PP6:ver<0.0.1>;

use Grammar::Tracer;

class Node {
    has Str $.tag;
    has @.content;

    submethod BUILD( :$!tag, :@!content ) {}
    
    method render {
	"<{$!tag}>{@.content.map( { $_.render } ).join("").chomp}</{$!tag}>";
    }
}

class Text {
    has Str $!text;

    submethod BUILD( :$!text ) {}
    
    method render {
	$!text;
    }
}

grammar Markdown {
    token TOP { <line>+ }
    token line { <-[\n]>+ \n? }
}

class MarkdownAction {
    has $.text;
    has $!current;
    has @!lines = [];

    method TOP($/) {
	
	if $!current {
	    @!lines.push( $!current );
	}
	$!text = make @!lines.map( *.render ).join("");
    }

    method line($/) {
	note $!current;
	if $!current {
	    if $!current.tag ~~ 'p' {
		$!current.content.push( Text.new( :text($/.Str) ) );
	    } else {
		make $!current.clone;
		$!current = Node.new( :tag<p>, :content[ Text.new( :text($/.Str) ) ] );
	    }
	} else {
	    $!current = Node.new( :tag<p>, :content[ Text.new( :text($/.Str) ) ] );
	}
    }
}

method to-html( Str $markdown ) {
    my $chomped = $markdown.chomp;
    my $actions = MarkdownAction.new;
    my $match = Markdown.parse( $markdown, :$actions );
        
    return "{$actions.text}\n";
}


=begin pod

=head1 NAME

CommonMark::PP6 - Pure Perl Implementation of CommonMark spec.

=head1 SYNOPSIS

=begin code :lang<perl6>

use CommonMark::PP6;

=end code

=head1 DESCRIPTION

CommonMark::PP6 is ...

=head1 AUTHOR

Simon Proctor <simon.proctor@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Simon Proctor

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

