import ../panda3d/core

type
  Actor* = object of NodePath

proc loadModel*(this: var Actor, modelPath: string) =
  var model = constructNodePath(Loader.getGlobalPtr().loadSync(modelPath))
  {.emit: """
  (NodePath &)`this` = `model`;
  """}

#proc loadAnims*(this: Actor) =

proc loop*(this: Actor, animName: string) =
  discard
