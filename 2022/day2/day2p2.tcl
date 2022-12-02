set input [open input.txt]

set decrypter [dict create A rock B paper C scissors X lose Y draw Z win]
set pointMapping [dict create rock 1 paper 2 scissors 3 win 6 draw 3 lose 0]
set winnerMapping [dict create rock scissors paper rock scissors paper]

while {[gets $input line] >= 0} {
    lappend rounds [lmap letter [split $line { }] {dict get $decrypter $letter}] 
}

set points 0
foreach round $rounds {
    lassign $round opponent outcome
    if {$outcome eq {lose}} {
        set me [dict get $winnerMapping $opponent] 
    } elseif {$outcome eq {draw}} {
        set me $opponent
    } else {
        lassign [dict filter $winnerMapping value $opponent] me
    }
    incr points [dict get $pointMapping $me]
    incr points [dict get $pointMapping $outcome]
}
puts $points