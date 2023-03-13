proc move {dir} {
    global currentPixels allPixels minX maxX
    set newPixels {}
    set incrVal [expr {$dir == {right} ? 1 : -1}]
    foreach coord $currentPixels {
        lassign [split $coord ,] x y
        switch $dir {
            < {incr x -1}
            > {incr x}
            down {incr y -1}
        }
        set newCoord "$x,$y"
        if {
            $x < $minX || $x > $maxX ||
            $y < 0 ||
            [info exists allPixels($newCoord)]
        } {return false}
        lappend newPixels $newCoord
    }
    set currentPixels $newPixels
    return true
}

proc newRock {} {
    global rockNum currentPixels highestY

    incr rockNum
    set rockType [expr {$rockNum % 5}]

    set y [expr {$highestY + 4}]
    set y1 [expr {$y + 1}]
    set y2 [expr {$y + 2}]
    set y3 [expr {$y + 3}]
    
    set currentPixels [switch $rockType {
        0 {list "2,$y" "3,$y" "4,$y" "5,$y"}
        1 {list "3,$y" "2,$y1" "3,$y1" "4,$y1" "3,$y2"}
        2 {list "2,$y" "3,$y" "4,$y" "4,$y1" "4,$y2"}
        3 {list "2,$y" "2,$y1" "2,$y2" "2,$y3"}
        4 {list "2,$y" "3,$y" "2,$y1" "3,$y1"}
    }]
}

proc placeRock {} {
    global allPixels currentPixels highestY

    foreach coord $currentPixels {
        set allPixels($coord) {}
        lassign [split $coord ,] x y
        if {$y > $highestY} {set highestY $y}
    }

    # set displayBoard [lrepeat [expr {$highestY + 3}] [list . . . . . . .]]
    # foreach coord [array names allPixels] {
    #     lassign [split $coord ,] x y
    #     puts "$x $y"
    #     lset displayBoard $y $x "#"
    # }
    # foreach row [lreverse $displayBoard] {
    #     puts [join $row " "]
    # }
    # puts ""
    newRock
}

set input [string trim [read [open input.txt]]]

set currentPixels {}

set highestY -1

set minX 0
set maxX 6

set rockNum -1
newRock

set inputPtr 0
set inputLen [string length $input]

while {$rockNum < 2022} {
    set inputChar [string index $input $inputPtr]
    set inputPtr [expr {($inputPtr + 1) % $inputLen}]

    move $inputChar

    if {![move down]} {placeRock}
}

puts [expr {$highestY + 1}]