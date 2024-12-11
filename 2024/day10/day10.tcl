proc recur {grid i j} {
    set curr [lindex $grid $i $j]
    if {$curr == 9} {return [list "$i $j"]}
    list \
        {*}[expr {[lindex $grid $i+1 $j] eq ($curr + 1) ? [recur $grid [expr {$i+1}] $j] : {}}] \
        {*}[expr {[lindex $grid $i-1 $j] eq ($curr + 1) ? [recur $grid [expr {$i-1}] $j] : {}}] \
        {*}[expr {[lindex $grid $i $j+1] eq ($curr + 1) ? [recur $grid $i [expr {$j+1}]] : {}}] \
        {*}[expr {[lindex $grid $i $j-1] eq ($curr + 1) ? [recur $grid $i [expr {$j-1}]] : {}}]
}

set input [open input.txt]
while {[gets $input line] >= 0} {
    lappend grid [split $line ""]
}
for {set i 0} {$i < [llength $grid]} {incr i} {
    for {set j 0} {$j < [llength [lindex $grid $i]]} {incr j} {
        if {[lindex $grid $i $j] == 0} {
            set rec [recur $grid $i $j]
            incr sum1 [llength [lsort -unique $rec]]
            incr sum2 [llength $rec]
        }
    }
}
puts "Part 1: $sum1\nPart 2: $sum2"
