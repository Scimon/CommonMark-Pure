use v6;

#use Grammar::Tracer;

grammar CommonMark::PP6::MarkdownGrammar is export {
    token TOP { <block>+ }
    token block { <block-type> }
    token block-type { <atx-heading> || <setx-heading> || <hrule> || <para> || <blank> }
    token blank { \n }
    token para { <-[ \n ]>+ \n }
    token atx-heading { " "**0..3 ("#"**1..6) (" " (<-[ \n ]>*))? \n }
    token setx-heading { " "**0..3 $<type>=("=" | "-")+ " "* \n }
    token hrule { " "**0..3 ( <hrule-star> | <hrule-dash> | <hrule-under> ) " "* \n }
    token hrule-star  { "*" " "* "*" " "* "*" (" "|"*")* }
    token hrule-dash  { "-" " "* "-" " "* "-" (" "|"-")* }
    token hrule-under { "_" " "* "_" " "* "_" (" "|"_")* }
}
