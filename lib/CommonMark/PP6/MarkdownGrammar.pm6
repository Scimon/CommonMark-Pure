use v6;

#use Grammar::Tracer;

grammar CommonMark::PP6::MarkdownGrammar is export {
    token TOP { <block>+ }
    token block { <block-type> }
    token block-type { <atx-heading> || <setx-heading> || <hrule> || <para> || <blank> }
    token blank { \n }
    token start-indent { " "**0..3 }
    token para { <start-indent> $<text>=(<-[ \n ]>+) \n }
    token atx-heading { <start-indent> ("#"**1..6) (" " (<-[ \n ]>*))? \n }
    token setx-heading { <start-indent> $<type>=("=" | "-")+ " "* \n }
    token hrule { <start-indent> ( <hrule-star> | <hrule-dash> | <hrule-under> ) " "* \n }
    token hrule-star  { "*" " "* "*" " "* "*" (" "|"*")* }
    token hrule-dash  { "-" " "* "-" " "* "-" (" "|"-")* }
    token hrule-under { "_" " "* "_" " "* "_" (" "|"_")* }
}
