set input [open input.txt]

set cycle 1
set x 1
set nextop readline

while {$cycle <= 220} {
    if {($cycle + 20) % 40 == 0 && $nextop ne {readline}} {
        incr result [expr {$cycle * $x}]
    }
    switch $nextop {
        noop {incr cycle; set nextop readline}
        addx {incr cycle; set nextop addx2}
        addx2 {
            incr cycle
            incr x $operand
            set nextop readline
        }
        readline {lassign [gets $input] nextop operand}
    }
}

puts $result