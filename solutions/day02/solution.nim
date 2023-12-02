import std/[strutils, sugar]

const example* = slurp("example.txt").strip()
const input* = slurp("input.txt").strip()

type 
  Turn = object
    cubes: seq[(int, string)]

  Game = object
    turns: seq[Turn]

proc parseInput(input: string): seq[Game] =
  for line in input.splitLines:
    result.add Game()
    let turns = line.split(":")[1]
    for turn in turns.split(";"):
      result[^1].turns.add Turn()
      for cube in turn.split(","):
        let s = cube.strip().split()
        result[^1].turns[^1].cubes.add (parseInt(s[0]),s[1])

proc isValid(turn: Turn): bool =
  const limits = (red: 12, green: 13, blue: 14)
  for cube in turn.cubes:
    case cube[1]:
      of "red":
        if cube[0] > limits.red: return false
      of "green":
        if cube[0] > limits.green: return false
      of "blue":
        if cube[0] > limits.blue: return false
      else: discard
  return true

proc partOne*(input: string): int =
  var games = parseInput(input)
  for i, game in games:
    if collect(
      for turn in game.turns:
        if not turn.isValid: turn).len == 0:
      result += (i+1)


proc partTwo*(input: string): int =
  var games = parseInput(input)
  for i, game in games:
    var mins = (red: 0, green: 0, blue: 0)
    for turn in game.turns:
      for cube in turn.cubes:
        case cube[1]:
          of "red": mins.red = max(mins.red, cube[0])
          of "green": mins.green = max(mins.green, cube[0])
          of "blue": mins.blue = max(mins.blue, cube[0])
          else: discard
    result += mins.red * mins.green * mins.blue



when isMainModule:
  import std/unittest

  suite "day 2":
    test "part one":
      check partOne(example) == 8
      check partOne(input) == 2239
    test "part two":
      check partTwo(example) == 2286
      check partTwo(input) == 83435

