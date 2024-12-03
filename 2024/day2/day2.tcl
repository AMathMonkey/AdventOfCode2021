proc getDiffs {line} {
    set result [list]
    for {set i 0} {$i < [llength $line] - 1} {incr i} {
        lappend result [expr {[lindex $line $i+1] - [lindex $line $i]}]
    }
    return $result
}

proc validPos {arr} {
    foreach e $arr {
        if {$e < 1 || $e > 3} {return false}
    }
    return true
}

proc validNeg {arr} {
    foreach e $arr {
        if {$e < -3 || $e > -1} {return false}
    }
    return true
}

set safe1 0
set safe2 0
set input [open {input.txt}]
while {[gets $input line] >= 0} {
    set diffs [getDiffs $line]
    if {[validPos $diffs] || [validNeg $diffs]} {incr safe1}
    for {set i 0} {$i < [llength $line]} {incr i} {
        set diffs [getDiffs [lreplace $line $i $i]]
        if {[validPos $diffs] || [validNeg $diffs]} {incr safe2; break}
    }
}

puts "Part 1: $safe1\nPart 2: $safe2"
