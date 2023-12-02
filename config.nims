import std/[algorithm,os,sequtils]

task solve, "run all solutions":
  for dir in walkDir("solutions").toSeq().sortedByIt(it.path):
    selfExec "r --hint:all:off " & dir.path & "/solution.nim"
