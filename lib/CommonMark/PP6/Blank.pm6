use v6;

use CommonMark::PP6::Node;

class CommonMark::PP6::Blank does Node is export {
    method render { "" }

    multi method merge ( Node $new ) {
        return ( $new );
    }
}
