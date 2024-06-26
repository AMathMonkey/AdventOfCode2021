import strutils
import tables

let lines = readFile("input.txt").splitLines

type round = tuple[me: string, opponent: string]

let decrypter = {
  "A" : "rock",
  "B" : "paper",
  "C" : "scissors",
  "X" : "rock",
  "Y" : "paper",
  "Z" : "scissors",
}.toTable

let pointMapping = {
  "rock" : 1,
  "paper" : 2,
  "scissors" : 3,
  "win" : 6,
  "draw" : 3,
}.toTable

let winnerMapping = {
  "rock" : "scissors",
  "paper" : "rock",
  "scissors" : "paper",
}.toTable

var rounds = newSeq[round](lines.len)

for i, line in lines:
  let roundSplit = line.split
  rounds[i] = (me: decrypter[roundSplit[1]], opponent: decrypter[roundSplit[0]])

var points = 0

for (me, opponent) in rounds:
  points.inc pointMapping[me]
  if me == opponent: points.inc pointMapping["draw"]
  elif winnerMapping[me] == opponent: points.inc pointMapping["win"]

echo points