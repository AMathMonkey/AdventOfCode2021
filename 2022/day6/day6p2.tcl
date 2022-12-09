set markerLength 14

set input [read [open input.txt]]
set length [string length $input]

for {set i $markerLength} {$i <= $length} {incr i} {
    set buffer [split [string range $input $i-$markerLength $i-1] {}]
    if {[llength [lsort -unique $buffer]] == $markerLength} {
        puts $i
        break
    }
}