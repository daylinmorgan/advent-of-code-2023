import std/[strutils, os, macros, terminal]
#
# template loadInputs*(): untyped =
#   const callPath = getProjectPath()
#   const example* {.inject.} = slurp(callPath / "example.txt").strip()
#   const input* {.inject.} = slurp(callPath / "input.txt").strip()
#

# template solveInput*(input: string, p1: untyped, p2: untyped): untyped =
#   assert partOne(input) == p1
#   assert partTwo(input) == p2

macro solve*(arg: untyped): untyped =
  arg.expectKind nnkStmtList
  result = newStmtList()
  for stmt in arg:
    stmt.expectKind nnkCall
    stmt[0].expectKind nnkStrLit
    stmt[1].expectKind nnkStmtList
    for inputs in stmt[1]:
      inputs.expectKind nnkCall
      inputs[0].expectKind nnkIdent
      inputs[1].expectKind nnkStmtList
      let
        part = inputs[0]
        inputFile = stmt[0]
        output = inputs[1][0]
        msg = newLit(part.repr & "|" & inputFile.strVal)
      result.add quote do:
        block:
          const input = slurp(getProjectPath() / `inputFile`).strip()
          let solution = `part`(input)
          if solution == `output`:
            stdout.styledWriteLine fgGreen, `msg`
          else:
            stdout.styledWriteLine fgRed, `msg`
            stdout.writeLine "  expected: ", $`output`, "; got: ", solution

