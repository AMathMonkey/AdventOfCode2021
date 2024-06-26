# Reverse engineered my part 2 solution into a similar method to solve part 1
# but it's only like 70% the speed of the solution I already wrote

namespace path {::tcl::mathop ::tcl::mathfunc}
set grid [lmap row [split [read [open input.txt]] \n] {split $row {}}]

set rows [llength $grid]
set cols [llength [lindex $grid 0]]

set resultGrid [lrepeat $rows [lrepeat $cols 0]]

for {set i 1} {$i < ($rows - 1)} {incr i} {
    for {set j 1} {$j < ($cols - 1)} {incr j} {
        set val [lindex $grid $i $j]

        for {set downCounter [expr {$i + 1}]} {$downCounter != $rows} {incr downCounter} {
            if {[lindex $grid $downCounter $j] >= $val} {break}
        }
        if {$downCounter == $rows} {lset resultGrid $i $j 1; continue}

        for {set upCounter [expr {$i - 1}]} {$upCounter != -1} {incr upCounter -1} {
            if {[lindex $grid $upCounter $j] >= $val} {break}
        }
        if {$upCounter == -1} {lset resultGrid $i $j 1; continue}

        for {set rightCounter [expr {$j + 1}]} {$rightCounter != $cols} {incr rightCounter} {
            if {[lindex $grid $i $rightCounter] >= $val} {break}
        }
        if {$rightCounter == $cols} {lset resultGrid $i $j 1; continue}

        for {set leftCounter [expr {$j - 1}]} {$leftCounter != -1} {incr leftCounter -1} {
            if {[lindex $grid $i $leftCounter] >= $val} {break}
        }
        if {$leftCounter == -1} {lset resultGrid $i $j 1}
    }
}

set result [expr {2 * $rows + 2 * $cols - 4}]
foreach row $resultGrid {incr result [+ {*}$row]}
puts $result