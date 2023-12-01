import std/[strutils]

const example* = slurp("example.txt").strip()
const example2* = slurp("example2.txt").strip()
const input* = slurp("input.txt").strip()

proc parseInput(input: string): seq[string] =
  input.split("\n")

proc partOne*(input: string): int =
  let lines = parseInput(input)
  for line in lines:
    var digits: seq[char]
    for c in line:
      case c
      of '0'..'9':
        digits.add c
      else: discard
    result += parseInt(digits[0] & digits[^1])

type
  Number = enum
    zero = 0,
    one, two, three, four, five, six, seven, eight, nine

proc partTwo*(input: string): int =
  let lines = parseInput(input)
  for line in lines:
    var digits: seq[char]
    var i: int
    while i < line.len:
      let c = line[i]
      case c
      of '0'..'9':
        digits.add c
        inc i
      else:
        for number in Number.low..Number.high:
          if line[i..^1].startsWith($number):
            digits.add $number.ord
            # some numbers share chars
            # let's jump back an extra index to catch them
            i += len($number)-2
            break
        inc i
    result += parseInt(digits[0] & digits[^1])

when isMainModule:
  import std/unittest
  suite "day 1":
    test "part one":
      check partOne(example) == 142
      check partOne(input) == 54597
    test "part two":
      check partTwo(example2) == 281
      check partTwo(input) == 54504
