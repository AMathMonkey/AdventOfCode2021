set input [open input.txt]

set count 0

while {[gets $input line] >= 0} {
    lassign [split $line ,] range1 range2
    lassign [split $range1 -] range1Start range1End
    lassign [split $range2 -] range2Start range2End
    if {$range1Start >= $range2Start && $range1End <= $range2End ||
    $range2Start >= $range1Start && $range2End <= $range1End} {
        incr count
    }
}
puts $count