import ../../panda3d/core

type
  Loader* = ref object of RootObj

proc loadModel*(loader: Loader, modelPath: string) : NodePath =
  var loader = core.Loader.getGlobalPtr()
  return constructNodePath(loader.loadSync(modelPath))

var loader* = Loader()
