use v6;

unit class CommonMark::PP6:ver<0.0.1>;

class Text {
    has Str $!text;

    submethod BUILD( :$!text ) {}

    method perl { "Text:\{{$!text}\}" }

    method Str { $!text }

    method render {
	    $!text;
    }
}

class Node {
    has Str $.tag;
    has @.content;

    submethod BUILD( :$!tag, :@!content ) {}
    
    method render {
	    "<{$!tag}>{@.content.map( { $_.render } ).join("").chomp}</{$!tag}>";
    }

    method merge ( Node $new ) {
        if ( $new.tag ne $!tag ) {
            return (self, $new);
        }
        @!content = [ | @!content, Text.new( :text("\n" ) ), | $new.content ];
        return ( self );
    }
}



grammar Markdown {
    token TOP { <block>+ }
    token block { <block-type> \n? }
    token block-type { <heading> || <para> }
    token para { <-[ \n ]>+ }
    token heading { " "**0..3 ("#"**1..6) " " (<-[ \# \n ]>+) "#"* " "* }
}

class MarkdownAction {
    has $.html;
    has $!current-block;
    has @!blocks = [];

    method TOP($/) {
	
        if $!current-block {
            @!blocks.push( $!current-block );
        }
        $!html = make @!blocks.map( *.render ).join("\n");
    }

    method block-type($/) {
        given $/ {
            when $_<heading> { make $_<heading>.made }
            when $_<para> { make $_<para>.made }
        }
    }

    method heading($/) {
        my $level = $/[0].Str.codes;
        make Node.new( :tag( "h{$level}" ), :content[ Text.new( :text( $/[1].Str ))] );
    }

    method para($/)  {
       make Node.new( :tag( "p" ), :content[ Text.new( :text( $/.Str ))]);
    }

    method block($/) {
        my $made = $<block-type>.made;
        if $!current-block {
            if $!current-block.tag ~~ $made.tag  {
                $!current-block.content.push( | $made.content );
            } else {
                @!blocks.push( $!current-block.clone );
                $!current-block = $made.clone;
            }
        } else {
            $!current-block = $made.clone;
        }
    }
}

method to-html( Str $markdown ) {
    my $chomped = $markdown.chomp;
    my $actions = MarkdownAction.new;
    my $match = Markdown.parse( $markdown, :$actions );
        
    return "{$actions.html}\n";
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

