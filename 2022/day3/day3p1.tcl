package require struct::set

proc score {letter} {
    scan $letter %c val
    expr {$val - ([string is upper $letter] ? 38 : 96)}
}

set input [open input.txt]

while {[gets $input line] >= 0} {
    set halfway [expr {[string length $line] / 2}]
    set halves [lmap half [list \
        [string range $line 0 $halfway-1] \
        [string range $line $halfway end] \
    ] {split $half {}}]
    lappend letters [struct::set intersect {*}$halves]
}

set sum 0
foreach letter $letters {incr sum [score $letter]}
puts $sum