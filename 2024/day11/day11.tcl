proc iter {times counts} {
    for {set i 0} {$i < $times} {incr i} {
        set newCounts [dict create]
        dict for {k v} $counts {
            if {$k == 0} {
                dict incr newCounts 1 $v
            } elseif {[set len [string length $k]] % 2 == 0} {
                set midPoint [expr {$len / 2}]
                dict incr newCounts [scan [string range $k 0 $midPoint-1] %lld] $v
                dict incr newCounts [scan [string range $k $midPoint end] %lld] $v
            } else {dict incr newCounts [expr $k * 2024] $v}
        }
        set counts $newCounts
    }
    dict for {{} v} $counts {incr result $v}
    return $result
}

foreach i [gets [open input.txt]] {dict incr counts $i}
puts "Part 1: [iter 25 $counts]\nPart 2: [iter 75 $counts]"
