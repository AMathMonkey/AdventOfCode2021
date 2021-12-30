input =: fread 'input.txt'
reg =: rxcomp '([[:digit:]]+)-([[:digit:]]+) ([[:alpha:]]): (.*)'
valid =: {{
    'pos1 pos2 letter string' =: y
    pos1 =: 1 -~ ".pos1
    pos2 =: 1 -~ ".pos2
    letter =: 0 { letter
    (letter = string {~ pos1) ~: (letter = string {~ pos2)
}}
+/ valid"1 (< a: ; (<(< 0))) { (reg rxmatches input) rxfrom input
