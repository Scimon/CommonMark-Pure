use v6;

use CommonMark::Pure::Node;

class CommonMark::Pure::Break does Node is export {
    method render() { "<br />\n" }
}
