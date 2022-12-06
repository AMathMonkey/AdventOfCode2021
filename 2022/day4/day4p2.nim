import strutils
import sequtils

let lines = readFile("input.txt").splitLines

var count = 0

for line in lines:
  let
    ranges = line.split(',')
    range1Parsed = ranges[0].split('-').map(parseInt)
    range2Parsed = ranges[1].split('-').map(parseInt)
    range1 = (range1Parsed[0] .. range1Parsed[1])
    range2 = (range2Parsed[0] .. range2Parsed[1])
  if range1.a in range2 or
  range1.b in range2 or
  range2.a in range1 or
  range2.b in range1:
    inc count

echo count