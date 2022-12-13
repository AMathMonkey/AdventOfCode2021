package require json

set input [split [read [open input.txt]] \n]

proc compare {a b} {
    while {[llength $a] > 0 && [llength $b] > 0} {
        set a [lassign $a left]
        set b [lassign $b right]
        if {[string is integer $left] && [string is integer $right]} {
            if {$right < $left} {return false}
            if {$left < $right} {return true}
        } else {
            return [compare $left $right]
        }
    }
    if {[llength $a] == 0} {expr true} else {expr false}
}

while {[llength $input] > 0} {
    incr index
    set input [lassign $input line1 line2 {}]
    if {[compare [json::many-json2dict $line1] [json::many-json2dict $line2]]} {incr result $index}
}

puts $result