use v6;

use CommonMark::PP6::Text;
use CommonMark::PP6::Node;
use CommonMark::PP6::HRule;
use CommonMark::PP6::Blank;
use CommonMark::PP6::Para;
use CommonMark::PP6::SetXHeading;

class CommonMark::PP6::MarkdownActions is export {
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
        for <blank setx-heading atx-heading para hrule> -> $type {
            when $/{$type} {
                make $/{$type}.made;
                last;
            }
        }
    }

    method atx-heading($/) {
        my $level = $/[0].Str.codes;
        my $text = $/[1][0] ?? $/[1][0].Str !! "";
        
        $text = $text.subst( / <!after "\\"> "#"+ " "* $/, '' ).subst( / "\\" /, '', :g );
                
        make Node.new( :tag( "h{$level}" ), :content[ Text.new( :text( $text ))] );
    }

    method setx-heading($/) {

        my $type = $/<type>[0].Str;

        make SetXHeading.new( level => ($type ~~ "=" ?? 1 !! 2) );
    }

    method para($/)  {
       make Para.new( :tag( "p" ), :content[ Text.new( :text( $/.Str ))]);
    }

    method hrule($/) {
        make HRule.new();
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
