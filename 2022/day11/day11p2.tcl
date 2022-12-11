namespace path {::tcl::mathop}
set input [open input.txt]

while {[gets $input line] >= 0} {
    if {[regexp {Monkey (\d+):} $line {} monkeyNum]} {continue}
    if {[regexp {Starting items: (.*)} $line {} itemStr]} {
        set m($monkeyNum,items) [split [string map [list {, } ,] $itemStr] ,]
        continue
    }
    if {[regexp {Operation: new = old (.) (\d+|old)} $line {} opSym opNum]} {
        set m($monkeyNum,opSym) $opSym
        set m($monkeyNum,opNum) $opNum
        continue
    }
    if {[regexp {divisible by (\d+)} $line {} testNum]} {
        set m($monkeyNum,testNum) $testNum
        continue
    }
    if {[regexp {If (true|false): throw to monkey (\d+)} $line {} trueFalse dest]} {
        set m($monkeyNum,${trueFalse}Dest) $dest
        continue
    }
}

set mod [* {*}[dict values [array get m *,testNum]]]

for {set round 1} {$round <= 10000} {incr round} {
    for {set i 0} {$i <= $monkeyNum} {incr i} {
        while {[llength $m($i,items)] > 0} {
            incr m($i,inspections)
            set m($i,items) [lassign $m($i,items) item]
            set opSym $m($i,opSym)
            set opNum $m($i,opNum)
            if {$opNum eq "old"} {set opNum $item}
            set item [expr {$item} $opSym {$opNum}]
            set item [expr {$item % $mod}]
            if {$item % $m($i,testNum) == 0} {
                set trueDest $m($i,trueDest)
                lset m($trueDest,items) end+1 $item
            } else {
                set falseDest $m($i,falseDest)
                lset m($falseDest,items) end+1 $item
            }
        }
    }
}


puts [* {*}[lrange [lsort -integer [dict values [array get m *,inspections]]] end-1 end]]