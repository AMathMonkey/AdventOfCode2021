import strutils
import tables
import sequtils
var 
  dirsToSizes = Table[string, int]()
  curPath: seq[string]

const 
  fileSystemSize = 70000000
  requiredFreeSpace = 30000000

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

let 
  usedSpace = dirsToSizes.values.toSeq.foldl(a + b)
  currentFreeSpace = fileSystemSize - usedSpace
  diff = requiredFreeSpace - currentFreeSpace

var result = fileSystemSize

for path, size in dirsToSizes:
  var sizesOfChildren = 0
  for key, value in dirsToSizes: 
    if key.startsWith(path & "/"): sizesOfChildren.inc(value)
  let recursiveSize = size + sizesOfChildren
  if recursiveSize >= diff and recursiveSize < result: 
    result = recursiveSize

echo result