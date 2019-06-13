use v6;

grammar CommonMark::PP6::MarkdownGrammar is export {
    token TOP { <block>+ }
    token block { <block-type> }
    token block-type { <rule> || <atx-heading> || <para> || <blank> }
    token blank { \n }
    token para { <-[ \n ]>+ \n }
    token atx-heading { " "**0..3 ("#"**1..6) (" " (<-[ \n ]>*))? \n }
    token rule { " "**0..3 ( <rule-star> | <rule-dash> | <rule-under> ) " "* \n }
    token rule-star  { "*" " "* "*" " "* "*" (" "|"*")* }
    token rule-dash  { "-" " "* "-" " "* "-" (" "|"-")* }
    token rule-under { "_" " "* "_" " "* "_" (" "|"_")* }
}
