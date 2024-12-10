def recur(goal, curr, rest, p2) {
    if (rest.empty) return curr == goal
    if (curr > goal) return false
    def newRest = rest.drop(1)
    recur(goal, curr + rest[0], newRest, p2) ||
        recur(goal, curr * rest[0], newRest, p2) ||
        p2 && recur(goal, "${curr}${rest[0]}".toLong(), newRest, p2)
}

def sum1 = 0
def sum2 = 0
('input.txt' as File).eachLine {
    def nums = (it =~ /\d+/).collect(String.&toLong)
    def rest = nums.drop(2)
    if (recur(nums[0], nums[1], rest, false)) sum1 += nums[0]
    if (recur(nums[0], nums[1], rest, true)) sum2 += nums[0]
}
println "Part 1: ${sum1}\nPart 2: ${sum2}"
