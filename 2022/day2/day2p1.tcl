set input [open input.txt]

set decrypter [dict create A rock B paper C scissors X rock Y paper Z scissors]
set pointMapping [dict create rock 1 paper 2 scissors 3 win 6 draw 3]
set winnerMapping [dict create rock scissors paper rock scissors paper]

while {[gets $input line] >= 0} {
    lappend rounds [lmap letter [split $line { }] {dict get $decrypter $letter}]
}

set points 0
foreach round $rounds {
    lassign $round opponent me
    incr points [dict get $pointMapping $me]
    if {$me eq $opponent} {
        incr points [dict get $pointMapping draw]
    } elseif {[dict get $winnerMapping $me] eq $opponent} {
        incr points [dict get $pointMapping win]
    }
}
puts $points