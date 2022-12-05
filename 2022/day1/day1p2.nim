import strutils
import sequtils
import algorithm

let lines = readFile("input.txt").splitLines

iterator getElves(lines: seq[string]): seq[int] = 
  var currentElf: seq[int] = @[]
  for line in lines:
    if line != "": currentElf.add(line.parseInt)
    else:
      yield currentElf
      currentElf = @[]

echo getElves(lines).toSeq.mapIt(it.foldl(a + b)).sorted[^3 .. ^1].foldl(a + b)