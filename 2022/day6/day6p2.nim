import deques

const markerLength = 14

template toSet(it): untyped =
  var result: set[it.T]
  for c in it: result.incl(c)
  result

let input = readFile("input.txt")

var buffer = initDeque[char]()

for i, c in input:
  buffer.addLast(c)
  if buffer.len == markerLength:
    if buffer.toSet.card == markerLength:
      echo i + 1
      break
    buffer.popFirst
