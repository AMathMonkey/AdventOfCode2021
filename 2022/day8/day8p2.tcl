namespace path {::tcl::mathop ::tcl::mathfunc}
set grid [lmap row [split [read [open input.txt]] \n] {split $row {}}]

set rows [llength $grid]
set cols [llength [lindex $grid 0]]

set resultGrid [lrepeat $rows [lrepeat $cols 0]]

for {set i 1} {$i < ($rows - 1)} {incr i} {
    for {set j 1} {$j < ($cols - 1)} {incr j} {

        set val [lindex $grid $i $j]

        set downCounter $i
        set downwardScore 0
        while {true} {
            incr downCounter
            if {$downCounter == $rows} {break}
            incr downwardScore
            if {[lindex $grid $downCounter $j] >= $val} {break}
        }
        
        set upCounter $i
        set upwardScore 0
        while {true} {
            incr upCounter -1
            if {$upCounter == -1} {break}
            incr upwardScore
            if {[lindex $grid $upCounter $j] >= $val} {break}
        }

        set rightCounter $j
        set rightwardScore 0
        while {true} {
            incr rightCounter
            if {$rightCounter == $cols} {break}
            incr rightwardScore
            if {[lindex $grid $i $rightCounter] >= $val} {break}
        }

        set leftCounter $j
        set leftwardScore 0
        while {true} {
            incr leftCounter -1
            if {$leftCounter == -1} {break}
            incr leftwardScore
            if {[lindex $grid $i $leftCounter] >= $val} {break}
        }

        lset resultGrid $i $j [* $downwardScore $upwardScore $rightwardScore $leftwardScore]
    }
}

set max 0
foreach row $resultGrid {
    foreach entry $row {
        set max [max $max $entry]
    }
}
puts $max
