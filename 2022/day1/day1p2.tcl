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

foreach elf $elves {
    set sum 0
    foreach num $elf {incr sum $num}
    lappend sums $sum
}

set sum 0
foreach top3Sum [lrange [lsort -integer $sums] end-2 end] {
    incr sum $top3Sum
}

puts $sum