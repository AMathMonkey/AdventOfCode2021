import strutils
import sequtils

template toSet[T](it: iterable[T]): set[T] =
  block:
    var result: set[T]
    for c in it: result.incl(c)
    result

func score(letter: char): int =
  letter.ord - (if letter.isUpperAscii: 38 else: 96)

let lines = readFile("input.txt").splitLines

var total = 0

for i in countup(0, lines.high, 3):
  for letter in lines[i .. i + 2].mapIt(it.items.toSet).foldl(a * b):
    total.inc(letter.score)

echo total