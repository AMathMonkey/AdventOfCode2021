namespace path {::tcl::mathop ::tcl::mathfunc}
set input [open input.txt]

set x 0; set y 0
set tailX 0; set tailY 0
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
        lassign [moveTail $x $y $tailX $tailY] tailX tailY
        set tailLocations([list $tailX $tailY]) {}
    }
} 
puts [array size tailLocations]