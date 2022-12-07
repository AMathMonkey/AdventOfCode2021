import strutils
import sequtils

func toCharSet(s: string): set[char] =
  for c in s: result.incl(c)

func score(letter: char): int =
  letter.ord - (if letter.isUpperAscii: 38 else: 96)

let lines = readFile("input.txt").splitLines

var total = 0

for i in countup(0, lines.high, 3):
  for letter in lines[i .. i + 2].map(toCharSet).foldl(a * b):
    total.inc(letter.score)

echo total