import std/[strutils, strscans]

const example* = slurp("example.txt").strip()
const input* = slurp("input.txt").strip()

type
  Color {.pure.} = enum
    red, blue, green

  Cubes = array[Color, int]
  Game = object
    turns: seq[Cubes]

proc parseInput(input: string): seq[Game] =
  for line in input.splitLines:
    result.add Game()
    let turns = line.split(":")[1]
    for turn in turns.split(";"):
      var cubes: Cubes
      for cubeStr in turn.split(","):
        var cnt: int
        var color: string
        discard cubeStr.strip().scanf("$i $w", cnt, color)
        cubes[parseEnum[Color](color)] = cnt
      result[^1].turns.add cubes

proc isValid(game: Game): bool =
  const limits: Cubes = [red: 12, blue: 14, green: 13]
  for turn in game.turns:
    for col, cnt in turn:
      if cnt > limits[col]:
        return false
  return true

proc partOne*(input: string): int =
  var games = parseInput(input)
  for i, game in games:
    if game.isValid():
      result += (i+1)

proc partTwo*(input: string): int =
  var games = parseInput(input)
  for i, game in games:
    var mins: Cubes
    for turn in game.turns:
      for col, cnt in turn:
        mins[col] = max(mins[col], cnt)
    result += mins[red] * mins[green] * mins[blue]


when isMainModule:
  import std/unittest
  suite "day 2":
    test "part one":
      check partOne(example) == 8
      check partOne(input) == 2239
    test "part two":
      check partTwo(example) == 2286
      check partTwo(input) == 83435
