namespace path {::tcl::mathop ::tcl::mathfunc}
set input [open input.txt]
set dirsToSizes [dict create]

set incrCurrentDir {dict incr dirsToSizes [join $curPath /]}

while {[gets $input line] >= 0} {
    switch -glob $line {
        {$ cd /} {
            set curPath /
            eval $incrCurrentDir 0
        }
        {$ cd ..} {set curPath [lrange $curPath 0 end-1]}
        {$ cd *} {
            lappend curPath [lindex $line 2]
            eval $incrCurrentDir 0
        }
        {dir *} - {$ ls} {}
        default {eval $incrCurrentDir [lindex $line 0]}
    }
}

foreach dir [dict keys $dirsToSizes] {
    set size [dict get $dirsToSizes $dir]
    set sizesOfChildren [dict values [dict filter $dirsToSizes key $dir/*]]
    set recursiveSize [+ $size {*}$sizesOfChildren]
    if {$recursiveSize <= 100000} {incr sum $recursiveSize}
}

puts $sum