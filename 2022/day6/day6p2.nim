import deques

const markerLength = 14

template toSet[T](it: iterable[T]): set[T] =
  block:
    var result: set[T]
    for c in it: result.incl(c)
    result

let input = readFile("input.txt")

var buffer = initDeque[char]()

for i, c in input:
  buffer.addLast(c)
  if buffer.len == markerLength:
    if buffer.items.toSet.card == markerLength:
      echo i + 1
      break
    buffer.popFirst
