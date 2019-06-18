use v6;

#use Grammar::Tracer;

grammar CommonMark::PP6::MarkdownGrammar is export {
    token TOP { <block>+ }
    token block { <block-type> }
    token block-type { <atx-heading> || <setx-heading> || <hrule> || <para> || <blank> }
    token blank { \n }
    token start-indent { " "**0..3 }
    token para { <start-indent> $<text>=(<-[ \n ]>+) \n }
    token atx-heading { <start-indent> ("#"**1..6) ((" "|\t)* $<text>=(<-[ \n ]>*))? \n }
    token setx-heading { <start-indent> $<type>=("=" | "-")+ (" "|\t)* \n }
    token hrule { <start-indent> ( <hrule-star> | <hrule-dash> | <hrule-under> ) " "* \n }
    token hrule-star  { "*" (" "|\t)* "*" (" "|\t)* "*" (\t|" "|"*")* }
    token hrule-dash  { "-" (" "|\t)* "-" (" "|\t)* "-" (\t|" "|"-")* }
    token hrule-under { "_" (" "|\t)* "_" (" "|\t)* "_" (\t|" "|"_")* }
}
