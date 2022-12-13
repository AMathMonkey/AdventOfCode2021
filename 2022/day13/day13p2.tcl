package require json

set input [split [read [open input.txt]] \n]
set input [lsearch -all -inline -exact -not $input {}]
set input [lmap line $input {json::many-json2dict $line}]
set divider1 [json::many-json2dict {[[2]]}]
set divider2 [json::many-json2dict {[[6]]}]
lappend input $divider1 $divider2

proc compare {a b} {
    while {[llength $a] > 0 && [llength $b] > 0} {
        set a [lassign $a left]
        set b [lassign $b right]
        if {[string is integer $left] && [string is integer $right]} {
            if {$right < $left} {return 1}
            if {$left < $right} {return -1}
        } else {
            return [compare $left $right]
        }
    }
    if {[llength $a] == 0} {expr -1} else {expr 1}
}

set input [lsort -command compare $input]

set result 1
foreach entry $input {
    incr index
    if {$entry in [list $divider1 $divider2]} {
        set result [expr {$result * $index}]
    }
}
puts $result