import ../../panda3d/core
import ../task
import ./DirectObject
import ./EventManagerGlobal
import ./EventManager
from ./Loader import loader

var render* = constructNodePath("render")

type
  ShowBase* = ref object of DirectObject
    cam*: NodePath
    camera*: NodePath
    camLens*: Lens
    camNode*: Camera
    graphicsEngine*: GraphicsEngine
    loader*: type(loader)
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

proc igLoop(this: ShowBase): auto =
  this.graphicsEngine.renderFrame()
  return Task.cont

proc getAspectRatio*(this: ShowBase): float =
  return this.win.getSbsLeftXSize() / this.win.getSbsLeftYSize()

proc adjustWindowAspectRatio*(this: ShowBase, aspectRatio: float) =
  this.camLens.aspectRatio = aspectRatio

proc windowEvent*(this: ShowBase) =
  this.adjustWindowAspectRatio(this.getAspectRatio())

proc openMainWindow*(this: ShowBase, props: WindowProperties = WindowProperties.getDefault()) =
  this.makeAllPipes()
  this.graphicsEngine = GraphicsEngine.getGlobalPtr()

  eventMgr.restart()
  this.accept("window-event", proc () = this.windowEvent())

  var fbprops = FrameBufferProperties.getDefault()
  this.win = this.graphicsEngine.makeOutput(this.pipe, "window", 0, fbprops, props, 0x0008)

  this.taskMgr = taskMgr
  this.loader = loader
  this.render = render
  this.camera = this.render.attachNewNode("camera")
  this.camNode = newCamera("cam")
  this.camLens = this.camNode.getLens()
  this.cam = this.camera.attachNewNode(this.camNode)

  var dr = this.win.makeDisplayRegion()
  dr.setCamera(this.cam)

  taskMgr.add(proc (task: Task): auto = this.igLoop(), "igLoop", 50)

  this.graphicsEngine.openWindows()

proc openDefaultWindow*(this: ShowBase, props: WindowProperties = WindowProperties.getDefault()): bool {.discardable.} =
  this.openMainWindow()
  return this.win != nil

proc run*(this: ShowBase) =
  taskMgr.run()
