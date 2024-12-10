def recur(goal, curr, rest, p2)
  return curr == goal if rest.empty?
  return if curr > goal
  newRest = rest[1..]
  recur(goal, curr + rest[0], newRest, p2) ||
    recur(goal, curr * rest[0], newRest, p2) ||
    p2 && recur(goal, "#{curr}#{rest[0]}".to_i, newRest, p2)
end

input = File.new("input.txt")
sum1 = 0
sum2 = 0
while line = input.gets
  nums = line.scan(/\d+/).map(&:to_i)
  rest = nums[2..]
  sum1 += nums[0] if recur(nums[0], nums[1], rest, false)
  sum2 += nums[0] if recur(nums[0], nums[1], rest, true)
end
puts "Part 1: #{sum1}\nPart 2: #{sum2}"
