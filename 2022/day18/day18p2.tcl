set input [open input.txt]

while {[gets $input line] >= 0} {
    set cubes($line) {}
}

set maxX -1
set maxY -1
set maxZ -1
# find max values of x y and z so steam can stop expanding after max + 1 of each axis
foreach cube [array names cubes] {
    lassign [split $cube ,] x y z
    if {$x > $maxX} {set maxX $x}
    if {$y > $maxY} {set maxY $y}
    if {$z > $maxZ} {set maxZ $z}
}
incr maxX
incr maxY
incr maxZ

set lastSize 0
set steam(-1,-1,-1) {}

# expand steam to fill area around lava droplet until no room is left
while {$lastSize != [set newSize [array size steam]]} {
    foreach steamCube [array names steam] {
        lassign [split $steamCube ,] x y z

        set index [set x1 [expr {$x+1}]],$y,$z
        if {$x1 <= $maxX && ![info exists cubes($index)]} {set steam($index) {}}

        set index [set xm1 [expr {$x-1}]],$y,$z
        if {$xm1 >= -1 && ![info exists cubes($index)]} {set steam($index) {}}

        set index $x,[set y1 [expr {$y+1}]],$z
        if {$y1 <= $maxY && ![info exists cubes($index)]} {set steam($index) {}}

        set index $x,[set ym1 [expr {$y-1}]],$z
        if {$ym1 >= -1 && ![info exists cubes($index)]} {set steam($index) {}}

        set index $x,$y,[set z1 [expr {$z+1}]]
        if {$z1 <= $maxZ && ![info exists cubes($index)]} {set steam($index) {}}

        set index $x,$y,[set zm1 [expr {$z-1}]]
        if {$zm1 >= -1 && ![info exists cubes($index)]} {set steam($index) {}}
    }
    set lastSize $newSize
}

# count cube faces that are in contact with steam
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
        if {[info exists steam($neighbour)]} {incr result}
    }
}

puts $result