def simulate(grid, coords)
  dir = "up"
  visited = Set.new
  cycles = Set.new
  (i, j) = coords
  loop do
    cycleKey = "#{i} #{j} #{dir}"
    return nil if cycles.include?(cycleKey)
    return visited unless checkBounds(grid, i, j)
    cycles << cycleKey
    visited << [i, j]
    (i1, j1) = advance(i, j, dir)
    while checkBounds(grid, i1, j1) && grid[i1][j1] == "#"
      dir = rotate(dir)
      (i1, j1) = advance(i, j, dir)
    end
    (i, j) = [i1, j1]
  end
end

def checkBounds(grid, i, j)
  i.between?(0, grid.length - 1) && j.between?(0, grid[i].length - 1)
end

def findStart(grid)
  grid.length.times do |i|
    grid[i].length.times do |j|
      return [i, j] if grid[i][j] == "^"
    end
  end
end

def advance(i, j, dir)
  case dir
    when "up" then [i - 1, j]
    when "down" then [i + 1, j]
    when "left" then [i, j - 1]
    when "right" then [i, j + 1]
  end
end

def rotate(dir)
  case dir
    when "up" then "right"
    when "down" then "left"
    when "left" then "up"
    when "right" then "down"
  end
end

sum2 = 0
lines = File.new("input.txt").readlines.map!(&:strip)
coords = findStart(lines)
visited = simulate(lines, coords)
visited.each do |i, j|
  next if i == coords[0] && j == coords[1]
  prev = lines[i][j]
  lines[i][j] = "#"
  sum2 += 1 if simulate(lines, coords).nil?
  lines[i][j] = prev
end
puts "Part 1: #{visited.length}\nPart 2: #{sum2}"