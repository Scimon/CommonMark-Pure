use v6;

#use Grammar::Tracer;

grammar CommonMark::Pure::MarkdownGrammar is export {
    token TOP { <block>+ }
    token block { <container> || <block-type> }
    token container { <blockquote> }
    token blockquote { <start-indent> ">" " "? $<inner>=(<blockquote> || <block-type> ) }
    token block-type { <atx-heading> || <setx-heading> || <indented-code> || <hrule> || <para> || <blank> }
    regex start-indent { " "**0..3 }
    token blank { <start-indent> \n }
    token para { <start-indent> $<text>=(<-[ \n ]>+) \n }
    token atx-heading { <start-indent>  ("#"**1..6) ((" "|\t)+ $<text>=(<-[ \# \n ]>*))? \n }
    token setx-heading { $<para>=<para> \n <start-indent> $<type>=("=" | "-")+ (" "|\t)* \n }
    token hrule { <start-indent> ( <hrule-star> | <hrule-dash> | <hrule-under> ) " "* \n }
    token hrule-star  { "*" (" "|\t)* "*" (" "|\t)* "*" (\t|" "|"*")* }
    token hrule-dash  { "-" (" "|\t)* "-" (" "|\t)* "-" (\t|" "|"-")* }
    token hrule-under { "_" (" "|\t)* "_" (" "|\t)* "_" (\t|" "|"_")* }
    regex indented-code { <start-indent> ("    "|\t) $<text>=(<-[ \n ]>+) \n }
}
