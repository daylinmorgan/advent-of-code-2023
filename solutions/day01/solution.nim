import std/[strutils]

import ../aoc

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

solve:
  "example.txt":
    partOne: 142
  "example2.txt":
    partTwo: 281
  "input.txt":
    partOne: 54597
    partTwo: 54504
