import strutils
import sequtils

template toSet(it): untyped =
  var result: set[typeof(it.items)]
  for c in it: result.incl(c)
  result

func score(letter: char): int =
  letter.ord - (if letter.isUpperAscii: 38 else: 96)

let lines = readFile("input.txt").splitLines

var total = 0

for i in countup(0, lines.high, 3):
  for letter in lines[i .. i + 2].mapIt(it.toSet).foldl(a * b):
    total.inc(letter.score)

echo total