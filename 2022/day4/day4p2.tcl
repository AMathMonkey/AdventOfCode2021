set input [open input.txt]

set count 0

proc between {num start end} {
    expr {$num >= $start && $num <= $end}
}

while {[gets $input line] >= 0} {
    lassign [split $line ,] range1 range2
    lassign [split $range1 -] range1Start range1End
    lassign [split $range2 -] range2Start range2End
    if {[between $range1Start $range2Start $range2End] ||
    [between $range1End $range2Start $range2End] ||
    [between $range2Start $range1Start $range1End] ||
    [between $range2End $range1Start $range1End]} {
        incr count
    }
}
puts $count