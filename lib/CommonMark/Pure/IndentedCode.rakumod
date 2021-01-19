use v6;

use CommonMark::Pure::Node;
use CommonMark::Pure::Text;
use CommonMark::Pure::Blank;

class CommonMark::Pure::IndentedCode does Node is export {
    method render {
        "<pre><code>{@.content.map( { $_.render } ).join("").chomp}\n</code></pre>";
    }

    multi method merge ( CommonMark::Pure::IndentedCode $new ) {
        $new.content = [ |self.content, Text.new( text => "\n" ), |$new.content ];
        return ( $new );
    }

    multi method merge ( CommonMark::Pure::Blank $new ) {
        self.content = [ |self.content, Text.new( text => "\n" ) ];
        return ( self );
    }

}
