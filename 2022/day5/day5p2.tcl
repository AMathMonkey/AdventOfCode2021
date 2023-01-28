set lines [split [read [open input.txt]] \n]

foreach line $lines {
    if {[string match {*\[*} $line]} {incr initLines; continue}
    set numStacks [lindex $line end]
    break
}

set stacks [lrepeat $numStacks [list]]

foreach line [lreverse [lrange $lines 0 $initLines-1]] {
    set letters [list]
    set len [string length $line]
    for {set i 1} {$i < $len} {incr i 4} {
        lappend letters [string index $line $i]
    }

    set i 0
    foreach letter $letters {
        if {$letter ne { }} {lset stacks $i end+1 $letter}
        incr i
    }
}

foreach line [lrange $lines $initLines+2 end] {
    regexp {move (\d+) from (\d+) to (\d+)} $line {} num src dest
    set srcStack [lindex $stacks $src-1]
    set destStack [lindex $stacks $dest-1]
    set popped [lreplace $srcStack 0 end-$num]
    lset stacks $src-1 [lrange $srcStack 0 end-$num]
    lset stacks $dest-1 [linsert $destStack end {*}$popped]
}

foreach stack $stacks {puts -nonewline [lindex $stack end]}
