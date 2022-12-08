namespace path ::tcl::mathop
set grid [lmap row [split [read [open input.txt]] \n] {split $row {}}]

set rows [llength $grid]
set cols [llength [lindex $grid 0]]

set resultGrid [lrepeat $rows [lrepeat $cols 0]]

proc checkIfTallest {} {
    upvar grid grid i i j j tallest tallest resultGrid resultGrid
    if {[lindex $grid $i $j] > $tallest} {
        set tallest [lindex $grid $i $j]
        lset resultGrid $i $j 1
    }
}

for {set i 0} {$i < $rows} {incr i} {
    set tallest [lindex $grid $i 0]
    lset resultGrid $i 0 1
    for {set j 1} {$j < $cols} {incr j} {checkIfTallest}
}

for {set i 0} {$i < $rows} {incr i} {
    set tallest [lindex $grid $i end]
    lset resultGrid $i end 1
    for {set j [expr {$cols - 2}]} {$j >= 0} {incr j -1} {checkIfTallest}
}

for {set j 0} {$j < $cols} {incr j} {
    set tallest [lindex $grid 0 $j]
    lset resultGrid 0 $j 1
    for {set i 1} {$i < $rows} {incr i} {checkIfTallest}
}

for {set j 0} {$j < $cols} {incr j} {
    set tallest [lindex $grid end $j]
    lset resultGrid end $j 1
    for {set i [expr {$rows - 2}]} {$i >= 0} {incr i -1} {checkIfTallest}
}

foreach row $resultGrid {incr result [+ {*}$row]}
puts $result
