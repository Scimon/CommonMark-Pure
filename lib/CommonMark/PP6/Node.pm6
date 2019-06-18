use v6;

use CommonMark::PP6::Renderable;

role CommonMark::PP6::Node does Renderable is export {
    has Str $.tag;
    has @.content;

    submethod BUILD( :$!tag = "", :@!content = [] ) {}

    method render {
        "<{$!tag}>{@.content.map( { $_.render } ).join("").chomp}</{$!tag}>";
    }

    multi method merge ( CommonMark::PP6::Node $new ) {
        if ( $new.tag ne $!tag ) {
            return (self, $new);
        }
        @!content = [ | @!content, | $new.content ];
        return ( self );
    }
}
