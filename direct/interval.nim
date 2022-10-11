import ../panda3d/core
import ../panda3d/direct

export direct

var lerpNodePathNum = 1
var sequenceNum = 1
var parallelNum = 1

proc posInterval*(nodePath: NodePath, duration: float, pos: VBase3, startPos: VBase3): CLerpNodePathInterval =
  let num = lerpNodePathNum
  lerpNodePathNum += 1
  var ival = newCLerpNodePathInterval("LerpPosInterval-" & $num, duration, CLerpInterval.BTNoBlend, true, false, nodePath, initNodePath())
  ival.setStartPos(startPos)
  ival.setEndPos(pos)
  return ival

proc hprInterval*(nodePath: NodePath, duration: float, hpr: VBase3, startHpr: VBase3): CLerpNodePathInterval =
  let num = lerpNodePathNum
  lerpNodePathNum += 1
  var ival = newCLerpNodePathInterval("LerpHprInterval-" & $num, duration, CLerpInterval.BTNoBlend, true, false, nodePath, initNodePath())
  ival.setStartHpr(startHpr)
  ival.setEndHpr(hpr)
  return ival

proc Sequence*(ivals: varargs[CInterval], name: string = ""): CMetaInterval =
  let num = sequenceNum
  sequenceNum += 1
  var meta = newCMetaInterval("Sequence-" & $num)
  for ival in ivals:
    discard meta.addCInterval(ival, 0, CMetaInterval.RSPreviousEnd)
  return meta

proc Parallel*(ivals: varargs[CInterval], name: string = ""): CMetaInterval =
  let num = parallelNum
  parallelNum += 1
  var meta = newCMetaInterval("Parallel-" & $num)
  for ival in ivals:
    discard meta.addCInterval(ival, 0, CMetaInterval.RSLevelBegin)
  return meta
