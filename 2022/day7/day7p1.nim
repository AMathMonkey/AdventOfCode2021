import strutils
import tables
var
  dirsToSizes = Table[string, int]()
  curPath: seq[string]

for line in "input.txt".lines:
  if line.startsWith "$ cd /":
    curPath = @["/"]
    discard dirsToSizes.hasKeyOrPut(curPath.join("/"), 0)
  elif line.startsWith "$ cd ..":
    discard curPath.pop
  elif line.startsWith "$ cd ":
    curPath.add(line.split[2])
    discard dirsToSizes.hasKeyOrPut(curPath.join("/"), 0)
  elif line.startsWith("$ ls").not and line.startsWith("dir ").not:
    dirsToSizes[curPath.join("/")].inc(line.split[0].parseInt)

var sum = 0
for path, size in dirsToSizes:
  var sizesOfChildren = 0
  for key, value in dirsToSizes:
    if key.startsWith(path & "/"): sizesOfChildren.inc(value)
  let recursiveSize = size + sizesOfChildren
  if recursiveSize <= 100000: sum.inc(recursiveSize)

echo sum