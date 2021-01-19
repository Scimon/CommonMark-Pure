use v6;

use CommonMark::Pure::Renderable;

role CommonMark::Pure::Node does Renderable is export {
    has Str $.tag;
    has @.content;

    submethod BUILD( :$!tag = "", :@!content = [] ) {}

    method render {
        "<{$!tag}>{@.content.map( { $_.render } ).join("").chomp}</{$!tag}>";
    }

    multi method merge ( CommonMark::Pure::Node $new ) {
        if ( $new.tag ne $!tag ) {
            return (self, $new);
        }
        @!content = [ | @!content, | $new.content ];
        return ( self );
    }
}
