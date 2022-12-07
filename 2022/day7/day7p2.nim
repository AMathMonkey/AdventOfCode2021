import strutils
import tables
import strformat
import sequtils
import algorithm

const 
  fileSystemSize = 70000000
  requiredFreeSpace = 30000000

type FileSystemNode = ref object
  name: string
  size: int
  children: seq[FileSystemNode]

func calcSize(self: FileSystemNode): int =
  for node in self.children: result.inc(node.calcSize)
  result.inc self.size

proc createDir(self: FileSystemNode, name: string): FileSystemNode = 
  let newDir = FileSystemNode(name: name)
  self.children.add newDir
  newDir

proc createFile(self: FileSystemNode, name: string, size: int) = 
  let newFile = FileSystemNode(name: name, size: size)
  self.children.add newFile

func `$`(self: FileSystemNode): string = 
  &"FileSystemNode(name: {self.name}, size: {self.calcSize}, #children: {self.children.len})"

var root = FileSystemNode(name: "/")
var current: FileSystemNode
var currentPath: seq[string]
var dirTable: Table[string, FileSystemNode] = {
  "/" : root
}.toTable

for line in lines("input.txt"):
  let tokens = line.split
  case tokens[0]:
  of "$": 
    if tokens[1] == "cd":
      case tokens[2]:
      of "/": 
        current = root
        currentPath = @["/"]
      of "..":
        discard currentPath.pop
        current = dirTable[currentPath.join(" ")]
      else: 
        currentPath.add tokens[2]
        current = dirTable[currentPath.join(" ")]
  of "dir":
    dirTable[(currentPath & @[tokens[1]]).join(" ")] = current.createDir(tokens[1])
  else: current.createFile(tokens[1], tokens[0].parseInt)

let 
  currentFreeSpace = fileSystemSize - root.calcSize
  diff = requiredFreeSpace - currentFreeSpace

echo dirTable.values.toSeq.mapIt(it.calcSize).filterIt(it > diff).sorted[0]