set input [open input.txt]

set height 6
set width 40
set offset 20
set pixels [expr {$height * $width}]

set cycle 1
set x 1
set nextop readline
set screen [lrepeat $pixels .] 

while {$cycle <= $pixels} {
    if {($cycle + $offset) % $width == 0 && $nextop ne {readline}} {
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
    if {abs(($cycle - 1) % $width - $x) <= 1} {lset screen $cycle-1 #}
}

for {set i 0} {$i < $pixels} {incr i $width} {
    set line [lrange $screen $i [expr {$i + $width - 1}]]
    puts [join $line {}]
}