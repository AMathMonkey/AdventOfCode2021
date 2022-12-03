package require struct::set

proc score {letter} {
    scan $letter %c val
    expr {$val - ([string is upper $letter] ? 38 : 96)}
}

set input [open input.txt]

while {[gets $input line1] >= 0} {
    gets $input line2
    gets $input line3
    set lines [list $line1 $line2 $line3]
    set lines [lmap line $lines {split $line {}}]
    lappend letters [struct::set intersect {*}$lines]
}

set sum 0
foreach letter $letters {incr sum [score $letter]}
puts $sum