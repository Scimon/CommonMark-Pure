use v6;

use CommonMark::Pure::Renderable;
use HTML::Escape;

class CommonMark::Pure::Text does Renderable is export {
    has Str $!text;
    has Bool $.trim is rw = False;
    has Bool $.escape is rw = False;

    submethod BUILD( :$!text, :$!trim = False, :$!escape = False ) {}

    method perl { "Text:\{{$!text}, Trim? {$!trim}, Esc? {$!escape}\}" }

    method Str { $!text }

    method render {
        self.apply-trim(self.apply-escape($!text));
    }

    method apply-trim($text) {
        self.trim ?? $text.trim !! $text
    }

    method apply-escape($text) {
        self.escape ?? escape-html($text) !! $text
    }
}
