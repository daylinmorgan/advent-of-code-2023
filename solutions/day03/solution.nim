import std/[strutils, sequtils, sets, tables]

const example* = slurp("example.txt").strip()
const input* = slurp("input.txt").strip()

type
  Pos = tuple[x, y: int]
  # Symbol = tuple[c: char, pos: Pos]
  Part = object
    val: int
    pos: Pos

proc parseInput(input: string): seq[Part] =
  var value: string
  var parts: seq[Part]
  for i, line in input.splitLines.toSeq():
    for j, c in line:
      if c in Digits:
        value.add c
        continue
      if value.len > 0:
        result.add Part(val: parseInt(value), pos: (x: j-value.len, y: i))
        parts.add result[^1]
        value = ""
    if value.len > 0:
      result.add Part(val: parseInt(value), pos: (x: line.len-1-value.len, y: i))
      parts.add result[^1]
      value = ""
    parts = @[]

proc dims(s: string): tuple[x: int, y: int] =
  let lines = s.splitLines()
  return (lines[0].len-1, lines.len-1)

let nonSymbols = (Digits + {'.'}).toSeq().toHashSet()

proc partNearSymbol(part: Part, input: string): bool =
  let dimensions = input.dims
  let
    minY = max(part.pos.y - 1, 0)
    minX = max(part.pos.x - 1, 0)
    maxX = min(part.pos.x + ($part.val).len, dimensions.x)
    maxY = min(part.pos.y + 1, dimensions.y)
  var chars: seq[char]
  for line in input.split("\n")[minY..maxY]:
    chars &= line[minX..maxX].toSeq()
  (chars.toHashSet() - nonSymbols).len > 0

proc partOne*(input: string): int =
  let parts = parseInput(input)
  for part in parts:
    if partNearSymbol(part, input):
      result += part.val

proc gearsNearPart(part: Part, input: string): seq[Pos] =
  let dimensions = input.dims
  let
    minY = max(part.pos.y - 1, 0)
    minX = max(part.pos.x - 1, 0)
    maxX = min(part.pos.x + ($part.val).len, dimensions.x)
    maxY = min(part.pos.y + 1, dimensions.y)
  for i, line in input.split("\n")[minY..maxY]:
    for j, c in line[minX..maxX]:
      if c == '*':
        result.add (x: minX+j, y: minY + i)

proc partTwo*(input: string): int =
  let parts = parseInput(input)
  var gears: Table[Pos, seq[Part]]
  for part in parts:
    for gear in gearsNearPart(part, input):
      if gear in gears: gears[gear].add part
      else: gears[gear] = @[part]

  for gear, parts in gears:
    if parts.len == 2:
      result += parts[0].val * parts[1].val

when isMainModule:
  import std/unittest

  suite "day 3":
    test "part one":
      check partOne(example) == 4361
      check partOne(input) == 536202
    test "part two":
      check partTwo(example) == 467835
      check partTwo(input) == 78272573
