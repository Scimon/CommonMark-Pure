use v6;

use CommonMark::PP6::Node;

class CommonMark::PP6::SetXHeading does Node is export {
    has $.level;

    submethod BUILD( :$!level, :@!content = [] ) {}

    method render { "<h{$.level}>{@.content.map( { $_.render } ).join("").chomp}</h{$.level}>" }

    multi method merge ( Node $new ) {
        return ( self, $new );
    }
}
