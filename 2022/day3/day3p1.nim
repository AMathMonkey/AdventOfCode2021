import strutils

template toSet[T](it: iterable[T]): set[T] =
  var result: set[T]
  for c in it: result.incl(c)
  result

func score(letter: char): int =
  letter.ord - (if letter.isUpperAscii: 38 else: 96)

let lines = readFile("input.txt").splitLines

var total = 0

for line in lines:
  let halfway = line.len div 2
  for letter in (line[0 ..< halfway].items.toSet) * (line[halfway .. ^1].items.toSet):
    total.inc(letter.score)

echo total