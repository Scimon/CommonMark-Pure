use v6;

use CommonMark::PP6::Node;
use CommonMark::PP6::SetXHeading;

class CommonMark::PP6::Para does Node is export {
    multi method merge ( SetXHeading $new ) {
        $new.content = self.content;
        return ( $new );
    }
}
