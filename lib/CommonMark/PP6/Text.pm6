use v6;

use CommonMark::PP6::Renderable;

class CommonMark::PP6::Text does Renderable is export {
    has Str $!text;

    submethod BUILD( :$!text ) {}

    method perl { "Text:\{{$!text}\}" }

    method Str { $!text }

    method render {
        $!text;
    }
}
