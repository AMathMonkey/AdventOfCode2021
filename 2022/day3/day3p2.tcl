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

set total 0

while {![eof $input]} {
    set splitLines [lmap line [getNLines 3 $input] {split $line {}}]
    foreach letter [struct::set intersect {*}$splitLines] {incr total [score $letter]}
}

puts $total