set input [open input.txt]

while {[gets $input line] >= 0} {
    set cubes($line) {}
}

foreach cube [array names cubes] {
    lassign [split $cube ,] x y z
    foreach neighbour [list \
        [expr {$x+1}],$y,$z \
        [expr {$x-1}],$y,$z \
        $x,[expr {$y+1}],$z \
        $x,[expr {$y-1}],$z \
        $x,$y,[expr {$z+1}] \
        $x,$y,[expr {$z-1}] \
    ] {
        if {![info exists cubes($neighbour)]} {incr result}
    }
} 

puts $result