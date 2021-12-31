input =: [;._2 fread 'input.txt'
'rows cols' =: $ input
solve =: {{
    'right down' =: y
    rowi =: ((rows > ])#]) down * i. rows
    coli =: cols | right * i. $ rowi
    +/ '#' = input {~ <"1 rowi ,. coli
}}
*/ (solve 1;2),(solve 7;1),(solve 5;1),(solve 3;1),(solve 1;1)
