use v6;

unit class CommonMark::PP6:ver<0.0.1>;

use Grammar::Tracer;

role Renderable {
    method render {...}
}

class Text does Renderable {
    has Str $!text;

    submethod BUILD( :$!text ) {}

    method perl { "Text:\{{$!text}\}" }

    method Str { $!text }

    method render {
        $!text;
    }
}

role Node does Renderable {
    has Str $.tag;
    has @.content;

    submethod BUILD( :$!tag = "", :@!content = [] ) {}

    method render {
        "<{$!tag}>{@.content.map( { $_.render } ).join("").chomp}</{$!tag}>";
    }

    method merge ( Node $new ) {
        if ( $new.tag ne $!tag ) {
            return (self, $new);
        }
        @!content = [ | @!content, | $new.content ];
        return ( self );
    }
}

class Rule does Node {
    method render { "<hr />" }

    method merge ( Node $new ) {
        return ( self, $new );
    }
}

class Blank does Node {
    method render { "" }

    method merge ( Node $new ) {
        return ( $new );
    }
}

grammar Markdown {
    token TOP { <block>+ }
    token block { <block-type> }
    token block-type { <rule> || <atx-heading> || <para> || <blank> }
    token blank { \n }
    token para { <-[ \n ]>+ \n }
    token atx-heading { " "**0..3 ("#"**1..6) (" " (<-[ \n ]>*))? \n }
    token rule { " "**0..3 ( <rule-star> | <rule-dash> | <rule-under> ) " "* \n }
    token rule-star  { "*" " "* "*" " "* "*" (" "|"*")* }
    token rule-dash  { "-" " "* "-" " "* "-" (" "|"-")* }
    token rule-under { "_" " "* "_" " "* "_" (" "|"_")* }
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
        for <blank atx-heading para rule> -> $type {
            when $/{$type} {
                make $/{$type}.made;
                last;
            }
        }
    }

    method atx-heading($/) {
        my $level = $/[0].Str.codes;
        my $text = $/[1][0].Str;
        
        $text = $text.subst( / <!after "\\"> "#"+ " "* $/, '' ).subst( / "\\" /, '', :g );
                
        make Node.new( :tag( "h{$level}" ), :content[ Text.new( :text( $text ))] );
    }

    method para($/)  {
       make Node.new( :tag( "p" ), :content[ Text.new( :text( $/.Str ))]);
    }

    method rule($/) {
        make Rule.new();
    }

    method blank($/) {
        make Blank.new();
    }

    method block($/) {
        my $made = $<block-type>.made;
        if $!current-block {
            my $new;
            ( $!current-block, $new ) = $!current-block.merge( $made );
            if ( $new ) {
                @!blocks.push( $!current-block.clone );
                $!current-block = $new.clone;
            }
        } else {
            $!current-block = $made.clone;
        }
    }
}

method to-html( Str $markdown is copy ) {
    if ( $markdown !~~ m!\n$! ) { $markdown ~= "\n" }
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
