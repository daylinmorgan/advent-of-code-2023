import std/[algorithm,os,sequtils]

task solve, "run all solutions":
  for dir in walkDirRec("solutions", yieldFilter = {pcDir}).toSeq().sortedByIt(it):
    echo "--",dir,"--"
    selfExec "r --hint:all:off " & dir & "/solution.nim"
