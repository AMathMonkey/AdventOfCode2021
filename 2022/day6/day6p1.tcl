set markerLength 4

set input [split [read [open input.txt]] {}]

for {set i 0} {$i < [llength $input]} {incr i} {
    lappend buffer [lindex $input $i]
    if {[llength $buffer] == $markerLength} {
        if {[llength [lsort -unique $buffer]] == $markerLength} {
            puts [expr {$i + 1}]
            break
        }
        set buffer [lrange $buffer 1 end]
    }
}