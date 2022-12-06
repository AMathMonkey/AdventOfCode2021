import strutils
import sets
import sequtils

func score(letter: char): int =
  letter.ord - (if letter.isUpperAscii: 38 else: 96)

let lines = readFile("input.txt").splitLines

var letters: seq[char] = @[]

for i in countup(0, lines.high, 3):
  for letter in (lines[i].toHashSet) * (lines[i + 1].toHashSet) * (lines[i + 2].toHashSet):
    letters.add(letter)

echo letters.map(score).foldl(a + b)