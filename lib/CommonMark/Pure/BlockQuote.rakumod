use v6;

use CommonMark::Pure::Node;
use CommonMark::Pure::Text;
use CommonMark::Pure::Para;

class CommonMark::Pure::BlockQuote does Node is export {  

    multi method merge ( CommonMark::Pure::BlockQuote $new ) {
        if $new.content[0].WHAT ~~ self.content[*-1].WHAT {
            self.content[*-1].content.push( Text.new( text => "\n"), |$new.content[0].content );
        } else {
            self.content = [ |self.content, Text.new( text => "\n"), |$new.content ];
        }
        return self;
    }

    multi method merge ( CommonMark::Pure::Para $new ) {
        if self.content[*-1].WHAT ~~ CommonMark::Pure::Para {
            self.content[*-1].content.push( Text.new( text => "\n"), |$new.content );
            return self;
        } else {
            return ( self, $new );
        }
    }

    method render {
        "<{$!tag}>\n{@.content.map( { $_.render } ).join("").chomp}\n</{$!tag}>";
    }

}
