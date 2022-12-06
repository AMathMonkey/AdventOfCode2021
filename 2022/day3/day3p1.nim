import strutils
import sets

func score(letter: char): int =
  letter.ord - (if letter.isUpperAscii: 38 else: 96)

let lines = readFile("input.txt").splitLines

var total = 0

for line in lines:
  let halfway = line.len div 2
  for letter in (line[0 ..< halfway].toHashSet) * (line[halfway .. ^1].toHashSet):
    total.inc(letter.score)

echo total