import math
import copy
import sys

def transform(ch): 
  return 'a' if ch == 'S' else 'z' if ch == 'E' else ch

def diff(src, dest):
  return ord(transform(dest)) - ord(transform(src))

with open('input.txt') as f:
  grid = [s.strip() for s in f.readlines()]

resultGrid = [[math.inf for _ in range(len(grid[0]))] for _ in range(len(grid))]
prevResultGrid = None

while prevResultGrid != resultGrid:
  prevResultGrid = copy.deepcopy(resultGrid)
  for rowNum, row in enumerate(grid):
    for colNum, elem in enumerate(row):
      curDist = resultGrid[rowNum][colNum]
      if elem == 'E':
        resultGrid[rowNum][colNum] = 0
        curDist = 0
      
      if colNum - 1 >= 0:
        valToLeft = grid[rowNum][colNum - 1]
        distToLeft = resultGrid[rowNum][colNum - 1]
        if distToLeft + 1 < curDist and diff(elem, valToLeft) <= 1:
          curDist = distToLeft + 1

      if colNum + 1 < len(row):
        valToRight = grid[rowNum][colNum + 1]
        distToRight = resultGrid[rowNum][colNum + 1]
        if distToRight + 1 < curDist and diff(elem, valToRight) <= 1:
          curDist = distToRight + 1

      if rowNum - 1 >= 0:
        valAbove = grid[rowNum - 1][colNum]
        distAbove = resultGrid[rowNum - 1][colNum]
        if distAbove + 1 < curDist and diff(elem, valAbove) <= 1:
          curDist = distAbove + 1
        
      if rowNum + 1 < len(grid):
        valBelow = grid[rowNum + 1][colNum]
        distBelow = resultGrid[rowNum + 1][colNum]
        if distBelow + 1 < curDist and diff(elem, valBelow) <= 1:
          curDist = distBelow + 1

      resultGrid[rowNum][colNum] = curDist

for rowNum, row in enumerate(grid):
  for colNum, elem in enumerate(row):
    if elem == 'S': 
      print(resultGrid[rowNum][colNum])
      sys.exit(0)
