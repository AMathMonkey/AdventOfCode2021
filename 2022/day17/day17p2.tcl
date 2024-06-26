proc move {dir} {
    global currentPixels allPixels minX maxX
    set newPixels {}
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
    global rockNum currentPixels highestY rockType

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

    newRock
}

set input [string trim [read [open input.txt]]]

set highestY -1

set minX 0
set maxX 6

set currentPixels {}
set rockNum -1
newRock

set inputPtr 0
set inputLen [string length $input]

while {$rockNum < 1000000000000} {
    if {$inputPtr == 0 && $rockType == 0 && $rockNum > 0} {
        lappend yVals $highestY
        lappend rockVals $rockNum
        if {[llength $yVals] == 2} {
            lassign $yVals y1 y2
            lassign $rockVals r1 r2
            set yDiff [expr {$y2 - $y1}]
            set rockDiff [expr {$r2 - $r1}]
            set cycles [expr {(1000000000000 - $rockNum) / $rockDiff}]
            incr rockNum [expr {$rockDiff * $cycles}]
        }
    }

    set inputChar [string index $input $inputPtr]
    set inputPtr [expr {($inputPtr + 1) % $inputLen}]

    move $inputChar
    if {![move down]} {placeRock}
}

puts [expr {$highestY + ($yDiff * $cycles) + 1}]