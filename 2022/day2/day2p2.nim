import strutils
import tables

let lines = readFile("input.txt").splitLines

type round = tuple[outcome: string, opponent: string]

let decrypter = {
  "A" : "rock",
  "B" : "paper",
  "C" : "scissors",
  "X" : "lose",
  "Y" : "draw",
  "Z" : "win",
}.toTable

let pointMapping = {
  "rock" : 1,
  "paper" : 2,
  "scissors" : 3,
  "win" : 6,
  "draw" : 3,
  "lose": 0,
}.toTable

let winnerMapping = {
  "rock" : "scissors",
  "paper" : "rock",
  "scissors" : "paper",
}.toTable

var rounds = newSeq[round](lines.len) 

for i, line in lines:
  let roundSplit = line.split
  rounds[i] = (outcome: decrypter[roundSplit[1]], opponent: decrypter[roundSplit[0]])

var points = 0

for (outcome, opponent) in rounds:
  var me: string
  case outcome:
    of "win": 
      for key, value in winnerMapping:
        if value == opponent: me = key; break
    of "lose": me = winnerMapping[opponent]
    of "draw": me = opponent
  points.inc pointMapping[outcome] + pointMapping[me]

echo points