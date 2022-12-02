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
    set me [switch $outcome {
        win {lindex [dict filter $winnerMapping value $opponent] 0}
        lose {dict get $winnerMapping $opponent}
        draw {expr {$opponent}}
    }]
    incr points [expr {[dict get $pointMapping $me] + [dict get $pointMapping $outcome]}]
}
puts $points