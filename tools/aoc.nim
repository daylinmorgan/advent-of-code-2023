import std/[httpclient, os, strformat, strutils, terminal, times]

let aocCookie = getEnv("AOC_COOKIE")

proc errQuit(msg: string) =
  stderr.styledWriteLine(fgRed, "AOCError", fgDefault, ": ", msg)
  quit 1

proc getInput(year, day: int): string =
  let url = fmt"https://adventofcode.com/{year}/day/{day}/input"
  var response: Response
  var client = newHttpClient()
  client.headers = newHttpHeaders({"Cookie": aocCookie})
  try:
    response = client.request(url)
  finally:
    client.close()
  return response.body().strip()

proc skeleton(day: int) =
  const solution = """
import std/[strutils]

const example* = slurp("example.txt").strip()
const input* = slurp("input.txt").strip()

proc parseInput(input: string)

proc partOne*(input: string): int = 0
proc partTwo*(input: string): int = 0

when isMainModule:
  echo partOne(example)
  echo partOne(input)
  echo partTwo(example)
  echo partTwo(input)
"""
  let test = fmt"""
import std/unittest
import ./solution

suite "day {day}":
  test "part one":
    check partOne(example) == 0
    check partOne(input) == 0
  test "part two":
    check partTwo(example) == 0
    check partTwo(input) == 0

"""
  let d = fmt"solutions/day{day:0>2}"
  writeFile(d / "solution.nim", solution)
  writeFile(d / "test.nim", test)

proc newDay(year, day: int) =
  let d = fmt"solutions/day{day:0>2}"
  createDir d
  let input = getInput(year, day)
  if input.startsWith "Puzzle inputs differ by user.":
    errQuit "faild to get input check cookie environemnt variable, AOC_COOKIE"
  elif input.startsWith "Please don't repeatedly request this endpoint before it unlocks!":
    errQuit "don't abuse the service and make sure the day exists first"
  writeFile(d / "input.txt", input)
  skeleton(day)



when isMainModule:
  import std/parseopt
  if not dirExists ".git":
    errQuit "only run from root dir of project"
  const help = """
     !
   -~*~-
    /!\
   /%;@\
  o/@,%\o
  /%;`@,\
 o/@'%',\o
 '^^^N^^^`

usage:
  aoc [opts]

options:
  -d, --day   int  day of the month
  -y, --year  int  day of the year
"""
  let today = now()
  var
    year = today.year
    day = parseInt(today.format("d"))

  for kind, key, val in getopt():
    case kind
    of cmdArgument:
      discard
    of cmdLongOption, cmdShortOption:
      case key:
      of "y", "year":
        year = parseInt(val)
      of "d", "day":
        day = parseInt(val)
      of "h", "help":
        echo help; quit 0
    of cmdEnd:
      discard

  echo "Fetching input for: "
  echo fmt"  year -> {year}"
  echo fmt"  day  -> {day}"
  newDay(year, day)
