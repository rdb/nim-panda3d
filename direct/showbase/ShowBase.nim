import ../../panda3d/core
import ../task
import ./DirectObject
import ./EventManagerGlobal
import ./EventManager
from ./Loader import loader

var aspect2d* = initNodePath(newPGTop("aspect2d"))
var render* = initNodePath("render")

type
  ShowBase* = ref object of DirectObject
    aspect2d*: NodePath
    cam*: NodePath
    camera*: NodePath
    camLens*: Lens
    camNode*: Camera
    clock*: ClockObject
    dataRoot*: NodePath
    dataRootNode*: PandaNode
    drive*: NodePath
    frameRateMeter*: FrameRateMeter
    graphicsEngine*: GraphicsEngine
    loader*: type(Loader.loader)
    mouse2cam*: NodePath
    mouseWatcher*: NodePath
    mouseWatcherNode*: MouseWatcher
    pipe*: GraphicsPipe
    render*: NodePath
    taskMgr*: TaskManager
    timeButtonThrower*: NodePath
    trackball*: NodePath
    win*: GraphicsOutput

proc makeDefaultPipe*(this: ShowBase) =
  var selection = GraphicsPipeSelection.getGlobalPtr()
  selection.printPipeTypes()
  this.pipe = selection.makeDefaultPipe()

proc makeAllPipes*(this: ShowBase) =
  if this.pipe == nil:
    this.makeDefaultPipe()

proc dataLoop(this: ShowBase): auto =
  var dgTrav = initDataGraphTraverser()
  dgTrav.traverse(this.dataRootNode)
  return Task.cont

proc igLoop(this: ShowBase): auto =
  this.graphicsEngine.renderFrame()
  return Task.cont

proc getAspectRatio*(this: ShowBase): float =
  return this.win.getSbsLeftXSize() / this.win.getSbsLeftYSize()

proc adjustWindowAspectRatio*(this: ShowBase, aspectRatio: float) =
  this.camLens.aspectRatio = aspectRatio

proc finalizeExit(this: ShowBase) =
  quit(0)

proc userExit(this: ShowBase) =
  this.finalizeExit()

proc windowEvent*(this: ShowBase, win: GraphicsWindow) =
  this.adjustWindowAspectRatio(this.getAspectRatio())

  var properties = win.getProperties()
  if not properties.open:
    this.userExit()

proc setupDataGraph*(this: ShowBase) =
  this.dataRoot = initNodePath("dataRoot")
  this.dataRootNode = this.dataRoot.node()

  this.trackball = initNodePath(newTrackball("trackball"))
  this.drive = initNodePath(newDriveInterface("drive"))
  this.mouse2cam = initNodePath(newTransform2SG("mouse2cam"))

proc setupMouse*(this: ShowBase, win: GraphicsWindow) =
  let name = win.getInputDeviceName(0)
  var mk = this.dataRoot.attachNewNode(newMouseAndKeyboard(win, 0, name))
  var mwn = newMouseWatcher("watcher0")
  var mw = mk.attachNewNode(mwn)

  if win.getSideBySideStereo():
      mwn.setDisplayRegion(win.getOverlayDisplayRegion())

  var mb = mwn.getModifierButtons()
  discard mb.addButton(KeyboardButton.shift())
  discard mb.addButton(KeyboardButton.control())
  discard mb.addButton(KeyboardButton.alt())
  discard mb.addButton(KeyboardButton.meta())
  mwn.setModifierButtons(mb)
  var btn = newButtonThrower("buttons0")
  discard mw.attachNewNode(btn)
  var mods = initModifierButtons()
  discard mods.addButton(KeyboardButton.shift())
  discard mods.addButton(KeyboardButton.control())
  discard mods.addButton(KeyboardButton.alt())
  discard mods.addButton(KeyboardButton.meta())
  btn.setModifierButtons(mods)

  this.mouseWatcher = mw
  this.mouseWatcherNode = mwn

  var timeButtonThrowerNode = newButtonThrower("timeButtons")
  this.timeButtonThrower = mw.attachNewNode(timeButtonThrowerNode)
  timeButtonThrowerNode.setPrefix("time-")
  timeButtonThrowerNode.setTimeFlag(true)

  # Tell the gui system about our new mouse watcher.
  dcast(PGTop, aspect2d.node()).setMouseWatcher(mwn)

  mwn.addRegion(newPGMouseWatcherBackground())

proc openMainWindow*(this: ShowBase, props: WindowProperties = WindowProperties.getDefault()) =
  this.makeAllPipes()
  this.graphicsEngine = GraphicsEngine.getGlobalPtr()

  eventMgr.restart()
  this.accept("window-event", proc (win: GraphicsWindow) = this.windowEvent(win))

  var fbprops: FrameBufferProperties = FrameBufferProperties.getDefault()
  this.win = this.graphicsEngine.makeOutput(this.pipe, "window", 0, fbprops, props, 0x0008)

  this.taskMgr = taskMgr
  this.loader = Loader.loader
  this.render = render
  this.aspect2d = aspect2d
  this.camera = this.render.attachNewNode("camera")
  this.camNode = newCamera("cam")
  this.camLens = this.camNode.getLens()
  this.cam = this.camera.attachNewNode(this.camNode)
  this.clock = ClockObject.getGlobalClock()

  this.setupDataGraph()

  var dr = this.win.makeDisplayRegion()
  dr.setCamera(this.cam)

  taskMgr.add(proc (task: Task): auto = this.dataLoop(), "dataLoop", -50)
  taskMgr.add(proc (task: Task): auto = this.igLoop(), "igLoop", 50)

  this.graphicsEngine.openWindows()

  if this.win.isOfType(GraphicsWindow):
    this.setupMouse(dcast(GraphicsWindow, this.win))

proc openDefaultWindow*(this: ShowBase, props: WindowProperties = WindowProperties.getDefault()): bool {.discardable.} =
  this.openMainWindow()
  return this.win != nil

proc setFrameRateMeter*(this: ShowBase, flag: bool) =
  if flag:
    if this.frameRateMeter == nil:
      this.frameRateMeter = newFrameRateMeter("frameRateMeter")
      this.frameRateMeter.setupWindow(this.win)
  else:
    if this.frameRateMeter != nil:
      this.frameRateMeter.clearWindow()
      this.frameRateMeter = nil

proc run*(this: ShowBase) =
  taskMgr.run()
