import strutils
import sequtils

let lines = readFile("input.txt").splitLines

var count = 0

for line in lines:
  let
    ranges = line.split(',')
    range1Parsed = ranges[0].split('-').map(parseInt)
    range2Parsed = ranges[1].split('-').map(parseInt)
    range1Start = range1Parsed[0]
    range1End = range1Parsed[1]
    range2Start = range2Parsed[0]
    range2End = range2Parsed[1]
  if range1Start >= range2Start and range1End <= range2End or
  range2Start >= range1Start and range2End <= range1End:
    inc count

echo count