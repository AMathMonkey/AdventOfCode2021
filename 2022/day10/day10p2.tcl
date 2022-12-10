set lines [split [read [open input.txt]] \n]

set lineNum 0

proc readline {} {
    global nextop operand lineNum lines
    set line [lindex $lines $lineNum]
    incr lineNum
    lassign [split $line { }] operator operand
    set nextop [switch $operator {
        noop {string cat noop}
        addx {string cat addx1}
    }]
}

set cycle 1
set x 1
set nextop readline
set screen [lrepeat 240 .] 
set pixelNum 0

while {$cycle <= 240} {
    if {($cycle + 20) % 40 == 0 && $nextop ne {readline}} {
        incr result [expr {$cycle * $x}]
    }
    switch $nextop {
        noop {incr cycle; set nextop readline}
        addx1 {incr cycle; set nextop addx2}
        addx2 {
            incr cycle
            incr x $operand
            set nextop readline
        }
        readline {readline}
    }
    if {abs(($cycle - 1) % 40 - $x) <= 1} {lset screen $cycle-1 #}
}

for {set i 0} {$i < 240} {incr i 40} {
    set line [lrange $screen $i [expr {$i + 40 - 1}]]
    puts [join $line {}]
}