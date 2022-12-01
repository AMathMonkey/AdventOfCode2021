set input [open input.txt]

while {[gets $input line] >= 0} {
    if {$line ne ""} {
        lappend currentElf $line
    } else {
        lappend elves $currentElf
        unset currentElf
    }
}
lappend elves $currentElf

set max 0
foreach elf $elves {
    set sum 0
    foreach num $elf {incr sum $num}
    if {$sum > $max} {set max $sum}
}

puts $max