set input [open input.txt]

set minRow 0

set maxRow 0
set minCol Inf
set maxCol 0
while {[gets $input line] >= 0} {
    set line [split [string map [list { -> } { }] $line] { }]
    set prevRow {}
    foreach point $line {
        lassign [split $point ,] col row
        if {$row > $maxRow} {set maxRow $row}
        if {$col < $minCol} {set minCol $col}
        if {$col > $maxCol} {set maxCol $col}

        if {$prevRow ne {}} {
            if {$prevCol == $col} {
                if {$row - $prevRow > 0} {
                    set sign 1
                    set op <=
                } else {
                    set sign -1
                    set op >=
                }
                for {} "\$prevRow $op \$row" {incr prevRow $sign} {
                    set grid($prevRow,$col) #
                }
            } else {
                if {$col - $prevCol > 0} {
                    set sign 1
                    set op <=
                } else {
                    set sign -1
                    set op >=
                }
                for {} "\$prevCol $op \$col" {incr prevCol $sign} {
                    set grid($row,$prevCol) #
                }
            }
        }
        set prevRow $row
        set prevCol $col
    }
}

set oldGrid {}
while {$oldGrid != [lsort [array get grid]]} {
    set oldGrid [lsort [array get grid]]

    set sandRow 0
    set sandCol 500
    
    set cond {$sandRow <= $maxRow && $sandCol <= $maxCol && $sandCol >= $minCol}
    while $cond {
        if {![info exists grid([expr {$sandRow + 1}],$sandCol)]} {
            incr sandRow
        } elseif {![info exists grid([expr {$sandRow + 1}],[expr {$sandCol - 1}])]} {
            incr sandRow
            incr sandCol -1
        } elseif {![info exists grid([expr {$sandRow + 1}],[expr {$sandCol + 1}])]} {
            incr sandRow
            incr sandCol
        } else {break}
    }

    if $cond {set grid($sandRow,$sandCol) o; incr result}
}

puts $result