import std/[math, sets, sequtils, strutils, macros]

import ../aoc

type
  Card = object
    winningNums: HashSet[int]
    nums: seq[int]

iterator parseInput(input: string): Card =
  for line in input.splitLines():
    var card: Card
    let s = line.split(":")[1].split("|")
    for num in s[0].strip().splitWhitespace():
      card.winningNums.incl parseInt(num)
    for num in s[1].strip().splitWhitespace():
      card.nums.add parseInt(num)
    yield card

proc partOne*(input: string): int =
  for card in parseInput(input):
    var score: int
    for num in card.nums:
      if num in card.winningNums:
        if score == 0: inc score
        else: score *= 2
    result += score


proc partTwo*(input: string): int =
  let cards = parseInput(input).toSeq()
  var winners = newSeq[int](cards.len)
  for i, card in cards:
    var score: int
    for num in card.nums:
      if num in card.winningNums:
        inc score
    inc winners[i]
    if score > 0:
      let copies = winners[i]
      for j in 1..score:
        winners[i+j].inc copies
  return winners.sum()


solve:
  example:
    partOne: 13
    partTwo: 30
  input:
    partOne: 22674
    partTwo: 5747443
