package require struct::set

proc score {letter} {
    scan $letter %c val
    expr {$val - ([string is upper $letter] ? 38 : 96)}
}

proc getNLines {n input} {
    for {set i 0} {$i < $n} {incr i} {
        gets $input line
        lappend result $line
    }
    return $result
}

set input [open input.txt]

while {![eof $input]} {
    set splitLines [lmap line [getNLines 3 $input] {split $line {}}]
    lappend letters [struct::set intersect {*}$splitLines]
}

set sum 0
foreach letter $letters {incr sum [score $letter]}
puts $sum