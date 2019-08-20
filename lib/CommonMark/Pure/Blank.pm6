use v6;

use CommonMark::Pure::Node;

class CommonMark::Pure::Blank does Node is export {
    method render { "" }

    multi method merge ( Node $new ) {
        return ( $new );
    }
}
