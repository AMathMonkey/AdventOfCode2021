import strutils

const markerLength = 4

func toCharSet(s: string): set[char] =
  for c in s: result.incl(c)

let input = readFile("input.txt")

var buffer = ""

for i, c in input:
  buffer.add(c)
  if buffer.len == markerLength:
    if buffer.toCharSet.card == markerLength:
      echo i + 1
      break
    buffer.delete(0..0)