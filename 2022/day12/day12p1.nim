import strutils
import sequtils

func diff(src, dest: char): int =
  func transform(chr: char): char = 
    if chr == 'S': 'a' elif chr == 'E': 'z' else: chr
  dest.transform.ord - src.transform.ord

let grid = readFile("input.txt").splitLines

var
  resultGrid = newSeqWith(grid.len, newSeqWith(grid[0].len, int.high - 1))
  prevResultGrid: seq[seq[int]]

while prevResultGrid != resultGrid:
  prevResultGrid = resultGrid
  for row in countup(grid.low, grid.high):
    for col in countup(grid[row].low, grid[row].high):
      let val = grid[row][col]
      var curDist = resultGrid[row][col]
      if val == 'E':
        resultGrid[row][col] = 0
        curDist = 0
      
      if col - 1 >= grid[row].low:
        let 
          valToLeft = grid[row][col - 1]
          distToLeft = resultGrid[row][col - 1]
        if distToLeft + 1 < curDist and diff(val, valToLeft) <= 1:
          curDist = distToLeft + 1

      if col + 1 <= grid[row].high:
        let 
          valToRight = grid[row][col + 1]
          distToRight = resultGrid[row][col + 1]
        if distToRight + 1 < curDist and diff(val, valToRight) <= 1:
          curDist = distToRight + 1

      if row - 1 >= grid.low:
        let 
          valAbove = grid[row - 1][col]
          distAbove = resultGrid[row - 1][col]
        if distAbove + 1 < curDist and diff(val, valAbove) <= 1:
          curDist = distAbove + 1
        
      if row + 1 <= grid.high:
        let
          valBelow = grid[row + 1][col]
          distBelow = resultGrid[row + 1][col]
        if distBelow + 1 < curDist and diff(val, valBelow) <= 1:
          curDist = distBelow + 1

      resultGrid[row][col] = curDist

for i, row in grid:
  for j, elem in row:
    if elem == 'S': 
      echo resultGrid[i][j]
      quit 0
