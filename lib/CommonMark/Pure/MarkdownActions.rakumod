use v6;

use CommonMark::Pure::Text;
use CommonMark::Pure::Node;
use CommonMark::Pure::HRule;
use CommonMark::Pure::Blank;
use CommonMark::Pure::Para;
use CommonMark::Pure::SetXHeading;
use CommonMark::Pure::IndentedCode;
use CommonMark::Pure::BlockQuote;

class CommonMark::Pure::MarkdownActions is export {
    has $.html;
    has $!current-block;
    has @!blocks = [];

    method TOP($/) {
        if $!current-block {
            @!blocks.push( $!current-block );
        }
        $!html = make @!blocks.map( *.render ).grep( ?* ).join("\n");
    }

    method blockquote($/) {
        make BlockQuote.new( :tag( "blockquote"), :content[ $/<block-type>.made ] );
    }

    method block-type($/) {
        for <blank setx-heading atx-heading para hrule indented-code> -> $type {
            when $/{$type} {
                make $/{$type}.made;
                last;
            }
        }
    }

    method atx-heading($/) {
        my $level = $/[0].Str.codes;
        my $text = $/[1]<text> ?? $/[1]<text>.Str !! "";
        
        $text = $text.subst( / <!after "\\"> "#"+ " "* $/, '' ).subst( / "\\" /, '', :g );
                
        make Node.new( :tag( "h{$level}" ), :content[ Text.new( :text( $text.trim ))] );
    }

    method indented-code($/) {
        make IndentedCode.new( :content[ Text.new( :text( $/<text>.Str ), :trim(False), :escape(True) ) ] );
    }
    
    method setx-heading($/) {

        my $type = $/<type>[0].Str;

        make SetXHeading.new( level => ($type ~~ "=" ?? 1 !! 2), :content[ Text.new( :text( $/<para><text>.Str.trim ))] );
    }

    method para($/)  {
       make Para.new( :tag( "p" ), :content[ Text.new( :text( $/<text>.Str.trim ))]);
    }

    method hrule($/) {
        make HRule.new();
    }

    method blank($/) {
        make Blank.new();
    }

    method container($/) {
        make $/<blockquote>.made;
    }

    method block($/) {
        my $made = $/<container>.made || $/<block-type>.made; 
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
