proc diff {src dest} {
    set mapping [list S a E z]
    set src [string map $mapping $src]
    set dest [string map $mapping $dest]
    scan "$src $dest" "%c %c" src dest
    expr {$dest - $src}
}

set input [split [read [open input.txt]] \n]
set grid [lmap line $input {split $line {}}]

set rows [llength $grid]
set cols [llength [lindex $grid 0]]

set resultGrid [lrepeat $rows [lrepeat $cols Inf]]
set prevResultGrid {}

while {$prevResultGrid ne $resultGrid} {
    set prevResultGrid $resultGrid
    for {set row 0} {$row < $rows} {incr row} {
        for {set col 0} {$col < $cols} {incr col} {
            set rowCol [list $row $col]
            set val [lindex $grid $rowCol]
            set curDist [lindex $resultGrid $rowCol]
            if {$val eq {E}} {
                lset resultGrid $rowCol 0
                set curDist 0
            }

            set valToLeft [lindex $grid $row $col-1]
            set distToLeft [lindex $resultGrid $row $col-1]

            set valToRight [lindex $grid $row $col+1]
            set distToRight [lindex $resultGrid $row $col+1]

            set valAbove [lindex $grid $row-1 $col]
            set distAbove [lindex $resultGrid $row-1 $col]

            set valBelow [lindex $grid $row+1 $col]
            set distBelow [lindex $resultGrid $row+1 $col]

            if {$valToLeft ne {} && $distToLeft + 1 < $curDist && [diff $val $valToLeft] <= 1} {
                set curDist [expr {$distToLeft + 1}]
            }
            if {$valToRight ne {} && $distToRight + 1 < $curDist && [diff $val $valToRight] <= 1} {
                set curDist [expr {$distToRight + 1}]
            }
            if {$valAbove ne {} && $distAbove + 1 < $curDist && [diff $val $valAbove] <= 1} {
                set curDist [expr {$distAbove + 1}]
            }
            if {$valBelow ne {} && $distBelow + 1 < $curDist && [diff $val $valBelow] <= 1} {
                set curDist [expr {$distBelow + 1}]
            }
            
            lset resultGrid $rowCol $curDist
        }
    }
}

for {set col 0} {$col < $cols} {incr col} {
    set row [lsearch -exact -index $col $grid S]
    if {$row > -1} {set startIndex [list $row $col]; break}
}

puts [lindex $resultGrid $startIndex]