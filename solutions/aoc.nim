import std/[strutils, os, macros, terminal]

template loadInputs*(): untyped =
  const callPath = getProjectPath()
  const example* {.inject.} = slurp(callPath / "example.txt").strip()
  const input* {.inject.} = slurp(callPath / "input.txt").strip()

template solveInput*(input: string, p1: untyped, p2: untyped): untyped =
  assert partOne(input) == p1
  assert partTwo(input) == p2

macro solve*(arg: untyped): untyped =
  arg.expectKind nnkStmtList
  result = newStmtList()
  for stmt in arg:
    stmt.expectKind nnkCall
    stmt[0].expectKind nnkIdent
    if not (stmt[0].eqIdent("example") or stmt[0].eqIdent("input")):
      error "Invalid input identifier: " & stmt[0].strVal
    stmt[1].expectKind nnkStmtList
    for inputs in stmt[1]:
      inputs.expectKind nnkCall
      inputs[0].expectKind nnkIdent
      inputs[1].expectKind nnkStmtList
      let
        part = inputs[0]
        puzzleInput = stmt[0]
        output = inputs[1][0]
        msg = newLit(part.repr & "|" & puzzleInput.repr)
      result.add quote do:
        let color =
          if `part`(`puzzleInput`) == `output`: fgGreen
          else: fgRed
        stdout.styledWriteLine(color, `msg`, fgDefault, ": ", $`output`)

loadInputs()
