use v6;

use CommonMark::PP6::Node;
use CommonMark::PP6::SetXHeading;
use CommonMark::PP6::Text;

class CommonMark::PP6::Para does Node is export {
    multi method merge ( SetXHeading $new ) {
        $new.content = self.content;
        return ( $new );
    }

    multi method merge ( CommonMark::PP6::Para $new ) {
        $new.content = [ self.content, Text.new( text => "\n"), $new.content ];
        return ( $new );
    }
}
