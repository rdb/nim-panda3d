import ../panda3d/core
import std/tables
import std/strutils

type
  AnimDef = object
    filename: string
    animControl: AnimControl

type
  Actor* = object of NodePath
    bundleDict: Table[string, PartBundle]
    partDict: Table[string, Table[string, AnimDef]]
    bundleNP: NodePath

proc loadModel*(this: var Actor, modelPath: string, partName: string = "modelRoot") =
  var model = initNodePath(Loader.getGlobalPtr().loadSync(modelPath))
  {.emit: """
  (NodePath &)`this` = `model`;
  """.}

  if model.node().isOfType(Character.getClassType()):
    this.bundleNP = model
  else:
    this.bundleNP = model.find("**/+Character")

  this.bundleDict[partName] = Character.dcast(this.bundleNP.node()).getBundle(0)

proc loadAnims*(this: var Actor, anims: openArray[(string, string)], partName: string = "modelRoot") =
  var animDict = addr this.partDict.mgetOrPut(partName, Table[string, AnimDef]())

  for i, (animName, filename) in anims:
    animDict[][animName] = AnimDef(filename: filename)

iterator children(this: PartGroup): PartGroup =
  var count = this.getNumChildren()
  for i in 0 ..< count:
    yield this.getChild(i)

proc doListJoints(this: var Actor, indentLevel: int, part: PartGroup) =
  var name = part.getName()
  var value : string

  if part.isOfType(MovingPartBase.getClassType()):
    var lineStream : LineStream
    dcast(MovingPartBase, part).outputValue(lineStream)
    value = lineStream.getLine()

  echo spaces(indentLevel), ' ', name, ' ', value

  for child in part.children:
    this.doListJoints(indentLevel + 2, child)

proc listJoints*(this: var Actor, partName: string = "modelRoot") =
  this.doListJoints(0, this.bundleDict[partName])

proc exposeJoint*(this: var Actor, node: NodePath, partName: string, jointName: string, localTransform: bool = false): NodePath =
  # Get a handle to the joint.
  var joint = dcast(CharacterJoint, this.bundleDict[partName].findChild(jointName))

  var node2: NodePath

  if node:
    node2 = node
  else:
    node2 = this.bundleNP.attachNewNode(jointName)

  if joint:
    if localTransform:
      discard joint.addLocalTransform(node2.node())
    else:
      discard joint.addNetTransform(node2.node())

  return node2

proc exposeJoint*(this: var Actor, node: type(nil), partName: string, jointName: string, localTransform: bool = false): NodePath =
  this.exposeJoint(this.bundleNP.attachNewNode(jointName), partName, jointName, localTransform)

proc stopJoint*(this: var Actor, partName: string, jointName: string) =
  # Get a handle to the joint.
  var joint = dcast(CharacterJoint, this.bundleDict[partName].findChild(jointName))

  if joint:
    joint.clearNetTransforms()
    joint.clearLocalTransforms()

proc controlJoint*(this: var Actor, node: NodePath, partName: string, jointName: string): NodePath =
  var anyGood = false

  var node2: NodePath

  var bundle = this.bundleDict[partName]
  if node:
    node2 = node
  else:
    node2 = this.attachNewNode(newModelNode(jointName))
    var joint = bundle.findChild(jointName)
    if joint and joint.isOfType(MovingPartMatrix.getClassType()):
      node2.setMat(MovingPartMatrix.dcast(joint).getDefaultValue())

  if bundle.controlJoint(jointName, node2.node()):
    anyGood = true

  return node2

proc controlJoint*(this: var Actor, node: type(nil), partName: string, jointName: string): NodePath =
  this.controlJoint(NodePath(), partName, jointName)

proc releaseJoint*(this: var Actor, partName: string, jointName: string) =
  discard this.bundleDict[partName].releaseJoint(jointName)

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

proc setPlayRate*(this: var Actor, rate: float, animName: string, partName: string = "modelRoot") =
  this.getAnimControl(animName, partName).setPlayRate(rate)
