use v6;

use CommonMark::Pure::Node;
use CommonMark::Pure::Text;

class CommonMark::Pure::IndentedCode does Node is export {
    method render {
        "<pre><code>{@.content.map( { $_.render } ).join("").chomp}\n</code></pre>";
    }

    multi method merge ( CommonMark::Pure::IndentedCode $new ) {
        $new.content = [ |self.content, Text.new( text => "\n"), |$new.content ];
        return ( $new );
    }
}
