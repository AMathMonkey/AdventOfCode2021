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
  for rowNum, row in grid:
    for colNum, elem in row:
      var curDist = resultGrid[rowNum][colNum]
      if elem == 'E':
        resultGrid[rowNum][colNum] = 0
        curDist = 0

      if colNum - 1 >= row.low:
        let
          valToLeft = grid[rowNum][colNum - 1]
          distToLeft = resultGrid[rowNum][colNum - 1]
        if distToLeft + 1 < curDist and diff(elem, valToLeft) <= 1:
          curDist = distToLeft + 1

      if colNum + 1 <= row.high:
        let
          valToRight = grid[rowNum][colNum + 1]
          distToRight = resultGrid[rowNum][colNum + 1]
        if distToRight + 1 < curDist and diff(elem, valToRight) <= 1:
          curDist = distToRight + 1

      if rowNum - 1 >= grid.low:
        let
          valAbove = grid[rowNum - 1][colNum]
          distAbove = resultGrid[rowNum - 1][colNum]
        if distAbove + 1 < curDist and diff(elem, valAbove) <= 1:
          curDist = distAbove + 1

      if rowNum + 1 <= grid.high:
        let
          valBelow = grid[rowNum + 1][colNum]
          distBelow = resultGrid[rowNum + 1][colNum]
        if distBelow + 1 < curDist and diff(elem, valBelow) <= 1:
          curDist = distBelow + 1

      resultGrid[rowNum][colNum] = curDist

for rowNum, row in grid:
  for colNum, elem in row:
    if elem == 'S':
      echo resultGrid[rowNum][colNum]
      quit 0
