use v6;

use CommonMark::PP6::Node;

class CommonMark::PP6::Rule does Node is export {
    method render { "<hr />" }

    method merge ( Node $new ) {
        return ( self, $new );
    }
}
