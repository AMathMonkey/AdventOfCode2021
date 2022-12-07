import strutils

func toCharSet(s: string): set[char] =
  for c in s: result.incl(c)

func score(letter: char): int =
  letter.ord - (if letter.isUpperAscii: 38 else: 96)

let lines = readFile("input.txt").splitLines

var total = 0

for line in lines:
  let halfway = line.len div 2
  for letter in (line[0 ..< halfway].toCharSet) * (line[halfway .. ^1].toCharSet):
    total.inc(letter.score)

echo total