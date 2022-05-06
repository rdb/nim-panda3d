import ../panda3d/core
import ./task

type
  DirectObject* = ref object of RootObj

type
  Loader* = ref object of RootObj

proc loadModel*(loader: Loader, modelPath: string) : NodePath =
  var loader = core.Loader.getGlobalPtr()
  return constructNodePath(loader.loadSync(modelPath))

var loader* = Loader()
var render* = constructNodePath("render")

type
  ShowBase* = ref object of DirectObject
    cam*: NodePath
    camera*: NodePath
    camNode*: Camera
    graphicsEngine*: GraphicsEngine
    loader*: Loader
    pipe*: GraphicsPipe
    render*: NodePath
    taskMgr*: TaskManager
    win*: GraphicsOutput

proc makeDefaultPipe*(this: ShowBase) =
  var selection = GraphicsPipeSelection.getGlobalPtr()
  selection.printPipeTypes()
  this.pipe = selection.makeDefaultPipe()

proc makeAllPipes*(this: ShowBase) =
  if this.pipe == nil:
    this.makeDefaultPipe()

proc igLoop(this: ShowBase): int =
  GraphicsEngine.getGlobalPtr().renderFrame()
  return 1

proc openMainWindow*(this: ShowBase, props: WindowProperties = WindowProperties.getDefault()) =
  this.makeAllPipes()
  this.graphicsEngine = GraphicsEngine.getGlobalPtr()

  var fbprops = FrameBufferProperties.getDefault()
  this.win = this.graphicsEngine.makeOutput(this.pipe, "window", 0, fbprops, props, 0x0008)

  this.loader = loader
  this.render = render
  this.camera = this.render.attachNewNode("camera")
  this.camNode = newCamera("cam")
  this.cam = this.camera.attachNewNode(this.camNode)

  var dr = this.win.makeDisplayRegion()
  dr.setCamera(this.cam)

  this.taskMgr.add(proc (): int = this.igLoop(), "igLoop", 50)

  this.graphicsEngine.openWindows()

proc openDefaultWindow*(this: ShowBase, props: WindowProperties = WindowProperties.getDefault()): bool {.discardable.} =
  this.openMainWindow()
  return this.win != nil

proc run*(this: ShowBase) =
  taskMgr.run()
