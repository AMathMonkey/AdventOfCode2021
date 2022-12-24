import strutils

template toSet(it: untyped): untyped =
  var result: set[typeof(it.items)]
  for c in it: result.incl(c)
  result

func score(letter: char): int =
  letter.ord - (if letter.isUpperAscii: 38 else: 96)

let lines = readFile("input.txt").splitLines

var total = 0

for line in lines:
  let halfway = line.len div 2
  for letter in (line[0 ..< halfway].toSet) * (line[halfway .. ^1].toSet):
    total.inc(letter.score)

echo total