import deques

const markerLength = 4

func toSet[T](c: openArray[T] or Deque[T]): set[T] =
  for e in c: result.incl(e)

let input = readFile("input.txt")

var buffer = initDeque[char]()

for i, c in input:
  buffer.addLast(c)
  if buffer.len == markerLength:
    if buffer.toSet.card == markerLength:
      echo i + 1
      break
    buffer.popFirst
