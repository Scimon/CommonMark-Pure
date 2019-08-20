use v6;

use CommonMark::Pure::Node;
use CommonMark::Pure::SetXHeading;
use CommonMark::Pure::Text;
use CommonMark::Pure::Break;
use CommonMark::Pure::IndentedCode;

class CommonMark::Pure::Para does Node is export {
    multi method merge ( SetXHeading $new ) {
        $new.content = self.content;
        return ( $new );
    }

    multi method merge ( CommonMark::Pure::Para $new ) {
        $new.content = [ |self.content, Text.new( text => "\n" ), |$new.content ];
        return ( $new );
    }

    multi method merge ( CommonMark::Pure::IndentedCode $new ) {
        $new.content.map( { $_.trim = True } );
        self.content = [ |self.content, Text.new( text => "\n"), |$new.content ];
        return ( self );
    }    
}
