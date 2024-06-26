namespace path {::tcl::mathop ::tcl::mathfunc}
set input [open input.txt]

set x 0; set y 0
set tails [lrepeat 9 [list 0 0]]
set tailLocations([list 0 0]) {}

proc moveHead {dir} {
    switch $dir {
        U {upvar y y; incr y}
        D {upvar y y; incr y -1}
        R {upvar x x; incr x}
        L {upvar x x; incr x -1}
    }
}

proc moveTail {x y tailX tailY} {
    if {abs($x - $tailX) <= 1 && abs($y - $tailY) <= 1} {return [list $tailX $tailY]}

    if {$x == $tailX && abs($y - $tailY) == 2} {
        incr tailY [expr {$y > $tailY ? 1 : -1}]
    } elseif {$y == $tailY && abs($x - $tailX) == 2} {
        incr tailX [expr {$x > $tailX ? 1 : -1}]
    } else {
        incr tailY [expr {$y > $tailY ? 1 : -1}]
        incr tailX [expr {$x > $tailX ? 1 : -1}]
    }
    list $tailX $tailY
}

while {[gets $input line] >= 0} {
    lassign $line dir num
    for {set times 0} {$times < $num} {incr times} {
        moveHead $dir
        for {set tailNum 0} {$tailNum < [llength $tails]} {incr tailNum} {
            lassign [lindex $tails $tailNum] tempX tempY
            lassign [if {$tailNum == 0} {list $x $y} else {lindex $tails $tailNum-1}] prevX prevY
            lset tails $tailNum [moveTail $prevX $prevY $tempX $tempY]
        }
        set tailLocations([lindex $tails end]) {}
    }
}
puts [array size tailLocations]