use v6;

use CommonMark::Pure::Node;

class CommonMark::Pure::HRule does Node is export {
    method render { "<hr />" }

    multi method merge ( Node $new ) {
        return ( self, $new );
    }
}
