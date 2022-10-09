import ../panda3d/core
import std/tables

type
  AnimDef = object
    filename: string
    animControl: AnimControl

type
  Actor* = object of NodePath
    bundleDict: Table[string, PartBundle]
    partDict: Table[string, Table[string, AnimDef]]

proc loadModel*(this: var Actor, modelPath: string, partName: string = "modelRoot") =
  var model = initNodePath(Loader.getGlobalPtr().loadSync(modelPath))
  {.emit: """
  (NodePath &)`this` = `model`;
  """.}

  var bundleNP: NodePath
  if model.node().isOfType(Character.getClassType()):
    bundleNP = model
  else:
    bundleNP = model.find("**/+Character")

  this.bundleDict[partName] = Character.dcast(bundleNP.node()).getBundle(0)

proc loadAnims*(this: var Actor, anims: openArray[(string, string)], partName: string = "modelRoot") =
  var animDict = addr this.partDict.mgetOrPut(partName, Table[string, AnimDef]())

  for i, (animName, filename) in anims:
    animDict[][animName] = AnimDef(filename: filename)

proc bindAnimToPart(this: var Actor, animName: string, partName: string): AnimControl {.discardable.} =
  var anim = addr this.partDict[partName][animName]

  var animControl = this.bundleDict[partName].loadBindAnim(Loader.getGlobalPtr(), anim.filename, -1, PartSubset(), false)
  anim.animControl = animControl
  return animControl

proc getAnimControl*(this: var Actor, animName: string, partName: string = "modelRoot"): AnimControl =
  if not this.partDict.hasKey(partName):
    return nil

  var animDict = addr this.partDict[partName]
  if not animDict[].hasKey(animName):
    return nil

  var anim = addr animDict[][animName]
  if not anim.animControl:
    this.bindAnimToPart(animName, partName)
  return anim.animControl

proc stop*(this: var Actor, animName: string, partName: string = "modelRoot") =
  this.getAnimControl(animName, partName).stop()

proc play*(this: var Actor, animName: string, partName: string = "modelRoot") =
  this.getAnimControl(animName, partName).play()

proc loop*(this: var Actor, animName: string, restart: bool = true, partName: string = "modelRoot") =
  this.getAnimControl(animName, partName).loop(restart)

proc pingpong*(this: var Actor, animName: string, restart: bool = true, partName: string = "modelRoot") =
  this.getAnimControl(animName, partName).pingpong(restart)

proc pose*(this: var Actor, animName: string, frame: float, partName: string = "modelRoot") =
  this.getAnimControl(animName, partName).pose(frame)

proc getCurrentAnim*(this: var Actor, partName: string = "modelRoot"): string =
  for animName, anim in this.partDict[partName]:
    if anim.animControl and anim.animControl.isPlaying():
      return animName
