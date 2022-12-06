import strutils
import sets
import sequtils

func score(letter: char): int =
  letter.ord - (if letter.isUpperAscii: 38 else: 96)

let lines = readFile("input.txt").splitLines

var letters: seq[char] = @[]

for line in lines:
  let halfway = line.len div 2
  for letter in (line[0 ..< halfway].toHashSet) * (line[halfway .. ^1].toHashSet):
    letters.add(letter)

echo letters.map(score).foldl(a + b)