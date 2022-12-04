import strutils
import sequtils

let lines = readFile("input.txt").splitLines

var count = 0

for line in lines:
  let
    ranges = line.split(',')
    range1Str = ranges[0]
    range2Str = ranges[1]
    range1Parsed =  range1Str.split('-').map(parseInt)
    range2Parsed = range2Str.split('-').map(parseInt)
    range1Start = range1Parsed[0]
    range1End = range1Parsed[1]
    range2Start = range2Parsed[0]
    range2End = range2Parsed[1]
    range1 = (range1Start .. range1End)
    range2 = (range2Start .. range2End)
  if range1Start in range2 or
  range1End in range2 or
  range2Start in range1 or
  range2End in range1:
    inc count

echo count