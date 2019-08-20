use v6;

use CommonMark::Pure::Renderable;

class CommonMark::Pure::Text does Renderable is export {
    has Str $!text;
    has Bool $.trim is rw = False;

    submethod BUILD( :$!text ) {}

    method perl { "Text:\{{$!text}\}" }

    method Str { $!text }

    method render {
        self.trim ?? $!text.trim !! $!text;
    }
}