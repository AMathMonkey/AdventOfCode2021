input =: fread 'input.txt'
reg =: rxcomp '([[:digit:]]+)-([[:digit:]]+) ([[:alpha:]]): (.*)'
valid =: verb define
    'min max letter string' =: y
    min =: ".min
    max =: ".max
    letter =: 0 { letter
    {{(y >: min) *. (y <: max)}} +/ letter = string
)
+/ valid"1 (< a: ; (<(< 0))) { (reg rxmatches input) rxfrom input
