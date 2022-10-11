import ../../panda3d/core
import ../task
import ./DirectObject
import ./EventManagerGlobal
import ./EventManager
from ./Loader import loader

var aspect2d* = initNodePath(newPGTop("aspect2d"))
var render* = initNodePath("render")
var render2d* = initNodePath("render2d")
aspect2d.reparentTo(render2d)

type
  ShowBase* = ref object of DirectObject
    a2dBackground*: NodePath
    a2dBottom*: float
    a2dBottomCenter*: NodePath
    a2dBottomLeft*: NodePath
    a2dBottomRight*: NodePath
    a2dLeft*: float
    a2dLeftCenter*: NodePath
    a2dRight*: float
    a2dRightCenter*: NodePath
    a2dTop*: float
    a2dTopCenter*: NodePath
    a2dTopLeft*: NodePath
    a2dTopRight*: NodePath
    aspect2d*: NodePath
    cam*: NodePath
    cam2d*: NodePath
    camera*: NodePath
    camera2d*: NodePath
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
    render2d*: NodePath
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
  if this.camLens != nil:
    this.camLens.aspectRatio = aspectRatio

  if aspectRatio < 1:
    # If the window is TALL, lets expand the top and bottom
    this.aspect2d.setScale(1.0, aspectRatio, aspectRatio)
    this.a2dTop = 1.0 / aspectRatio
    this.a2dBottom = - 1.0 / aspectRatio
    this.a2dLeft = -1
    this.a2dRight = 1.0
  else:
    # If the window is WIDE, lets expand the left and right
    this.aspect2d.setScale(1.0 / aspectRatio, 1.0, 1.0)
    this.a2dTop = 1.0
    this.a2dBottom = -1.0
    this.a2dLeft = -aspectRatio
    this.a2dRight = aspectRatio

  # Reposition the aspect2d marker nodes
  this.a2dTopCenter.setPos(0, 0, this.a2dTop)
  this.a2dBottomCenter.setPos(0, 0, this.a2dBottom)
  this.a2dLeftCenter.setPos(this.a2dLeft, 0, 0)
  this.a2dRightCenter.setPos(this.a2dRight, 0, 0)

  this.a2dTopLeft.setPos(this.a2dLeft, 0, this.a2dTop)
  this.a2dTopRight.setPos(this.a2dRight, 0, this.a2dTop)
  this.a2dBottomLeft.setPos(this.a2dLeft, 0, this.a2dBottom)
  this.a2dBottomRight.setPos(this.a2dRight, 0, this.a2dBottom)

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

proc getAspectRatio*(this: ShowBase, win: GraphicsWindow): float =
  var aspectRatio: float = 1

  if win != nil and win.hasSize() and win.getSbsLeftYSize() != 0:
    aspectRatio = float(win.getSbsLeftXSize()) / float(win.getSbsLeftYSize())
  else:
    var props: WindowProperties
    if win == nil:
      props = WindowProperties.getDefault()
    else:
      props = win.getRequestedProperties()
      if not props.hasSize():
        props = WindowProperties.getDefault()

    if props.hasSize() and props.getYSize() != 0:
      aspectRatio = float(props.getXSize()) / float(props.getYSize())

  if aspectRatio == 0:
    return 1

  return aspectRatio

proc makeCamera2d*(this: ShowBase, win: GraphicsWindow, sort: int = 10,
                   displayRegion: tuple[left: float32, right: float32, bottom: float32, top: float32] = (0f32, 1f32, 0f32, 1f32),
                   coords: tuple[left: float32, right: float32, bottom: float32, top: float32] = (-1f32, 1f32, -1f32, 1f32)): NodePath =

  var dr = win.makeMonoDisplayRegion(displayRegion.left, displayRegion.right,
                                     displayRegion.bottom, displayRegion.top)
  dr.setSort(sort)

  # Enable clearing of the depth buffer on this new display
  # region (see the comment in setupRender2d, above).
  dr.setClearDepthActive(true)

  # Make any texture reloads on the gui come up immediately.
  dr.setIncompleteRender(false)

  var (left, right, bottom, top) = coords

  # Now make a new Camera node.
  var cam2dNode = newCamera("cam2d")

  var lens = newOrthographicLens()
  lens.setFilmSize(right - left, top - bottom)
  lens.setFilmOffset((right + left) * 0.5, (top + bottom) * 0.5)
  lens.setNearFar(-1000, 1000)
  cam2dNode.setLens(lens)

  # this.camera2d is the analog of this.camera, although it's
  # not as clear how useful it is.
  if this.camera2d.isEmpty():
    this.camera2d = this.render2d.attachNewNode("camera2d")

  var camera2d = this.camera2d.attachNewNode(cam2dNode)
  dr.setCamera(camera2d)

  if this.cam2d.isEmpty():
    this.cam2d = camera2d

  return camera2d

proc setupRender2d*(this: ShowBase) =
  this.render2d.setDepthTest(false)
  this.render2d.setDepthWrite(false)
  this.render2d.setMaterialOff(1)
  this.render2d.setTwoSided(true)

  var aspectRatio = this.getAspectRatio()
  this.aspect2d.setScale(1.0 / aspectRatio, 1.0, 1.0)

  this.a2dBackground = this.aspect2d.attachNewNode("a2dBackground")

  # The Z position of the top border of the aspect2d screen.
  this.a2dTop = 1.0
  # The Z position of the bottom border of the aspect2d screen.
  this.a2dBottom = -1.0
  # The X position of the left border of the aspect2d screen.
  this.a2dLeft = -aspectRatio
  # The X position of the right border of the aspect2d screen.
  this.a2dRight = aspectRatio

  this.a2dTopCenter = this.aspect2d.attachNewNode("a2dTopCenter")
  this.a2dBottomCenter = this.aspect2d.attachNewNode("a2dBottomCenter")
  this.a2dLeftCenter = this.aspect2d.attachNewNode("a2dLeftCenter")
  this.a2dRightCenter = this.aspect2d.attachNewNode("a2dRightCenter")

  this.a2dTopLeft = this.aspect2d.attachNewNode("a2dTopLeft")
  this.a2dTopRight = this.aspect2d.attachNewNode("a2dTopRight")
  this.a2dBottomLeft = this.aspect2d.attachNewNode("a2dBottomLeft")
  this.a2dBottomRight = this.aspect2d.attachNewNode("a2dBottomRight")

  # Put the nodes in their places
  this.a2dTopCenter.setPos(0, 0, this.a2dTop)
  this.a2dBottomCenter.setPos(0, 0, this.a2dBottom)
  this.a2dLeftCenter.setPos(this.a2dLeft, 0, 0)
  this.a2dRightCenter.setPos(this.a2dRight, 0, 0)

  this.a2dTopLeft.setPos(this.a2dLeft, 0, this.a2dTop)
  this.a2dTopRight.setPos(this.a2dRight, 0, this.a2dTop)
  this.a2dBottomLeft.setPos(this.a2dLeft, 0, this.a2dBottom)
  this.a2dBottomRight.setPos(this.a2dRight, 0, this.a2dBottom)

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
  this.render2d = render2d
  this.aspect2d = aspect2d
  this.camera = this.render.attachNewNode("camera")
  this.camNode = newCamera("cam")
  this.camLens = this.camNode.getLens()
  this.cam = this.camera.attachNewNode(this.camNode)
  this.clock = ClockObject.getGlobalClock()

  this.setupDataGraph()

  var dr = this.win.makeDisplayRegion()
  dr.setCamera(this.cam)

  this.setupRender2d()

  discard this.makeCamera2d(dcast(GraphicsWindow, this.win))

  taskMgr.add(proc (task: Task): auto = this.dataLoop(), "dataLoop", -50)
  taskMgr.add(proc (task: Task): auto = this.igLoop(), "igLoop", 50)

  this.graphicsEngine.openWindows()

  if this.win.isOfType(GraphicsWindow):
    this.setupMouse(dcast(GraphicsWindow, this.win))

proc openDefaultWindow*(this: ShowBase, props: WindowProperties = WindowProperties.getDefault()): bool {.discardable.} =
  this.openMainWindow()
  return this.win != nil

proc setBackgroundColor*(this: ShowBase, color: LVecBase4) =
  this.win.setClearColor(color)

proc setBackgroundColor*(this: ShowBase, r: float, g: float, b: float) =
  this.setBackgroundColor(initLVecBase4f(r, g, b, 0.0f))

proc setBackgroundColor*(this: ShowBase, r: float, g: float, b: float, a: float) =
  this.setBackgroundColor(initLVecBase4f(r, g, b, a))

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
