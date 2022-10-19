# Author: Original python version by Ryan Myers
# Models: Jeff Styers, Reagan Heller
#
# Last Updated: 2015-03-13 (translated to nim in 2022 by Entikan)
#
# This tutorial provides an example of creating a character
# and having it walk around on uneven terrain, as well
# as implementing a fully rotatable camera.


import direct/showbase
import direct/task
import direct/actor
import panda3d/core

var base = ShowBase()
base.openDefaultWindow()

proc makeText(y:float, text: string, scale: float = 0.05) =
  var textnode = newTextNode("text")
  var nodepath = base.aspect2d.attach_new_node(textnode)
  textnode.set_text(text)
  nodepath.set_scale(scale)
  nodepath.set_pos(-0.8,0,0.8-y)

makeText(0, "Panda3D Tutorial: Roaming Ralph, written in Nim.", 0.06)
makeText(0.06, "[ESC]: Quit")
makeText(0.12, "[Left Arrow]: Rotate Ralph Left")
makeText(0.18, "[Right Arrow]: Rotate Ralph Right")
makeText(0.24, "[Up Arrow]: Run Ralph Forward")
makeText(0.30, "[Down Arrow]: Walk Ralph Backward")
makeText(0.36, "[A]: Rotate Camera Left")
makeText(0.42, "[S]: Rotate Camera Right")

var environ = base.loader.loadModel("models/world")
environ.reparentTo(base.render)

# We do not have a skybox, so we will just use a sky blue background color
base.setBackgroundColor(0.53, 0.80, 0.92, 1)

# Create the main character, Ralph
var
  ralphStartPos = environ.find("**/start_point").getPos()
  ralph = Actor()
ralph.loadModel("models/ralph")
ralph.loadAnims({"run":"models/ralph-run", "walk":"models/ralph-walk"})
ralph.reparentTo(base.render)
ralph.setScale(0.2)
ralph.setPos(ralphStartPos)
ralph.setPos(ralph, 0, 0, 1.5)

# Create a floater object, which floats 2 units above ralph.  We
# use this as a target for the camera to look at.
var floater = ralph.attach_new_node("floater")
floater.setZ(2.0)

# Set up the camera
base.disableMouse()
base.camera.setPos(ralph.getX(), ralph.getY() + 10, 2)


# Use a CollisionHandlerPusher to handle collisions between Ralph and
# the environment. Ralph is added as a "from" object which will be
# "pushed" out of the environment if he walks into obstacles.
#
# Ralph is composed of two spheres, one around the torso and one
# around the head.  They are slightly oversized since we want Ralph to
# keep some distance from obstacles.
var cTrav = CollisionTraverser()

var
  ralphCol = newCollisionNode("ralph")
  ralphColNp = ralph.attachNewNode(ralphCol)
  ralphPusher = newCollisionHandlerPusher()

discard ralphCol.addSolid(newCollisionSphere(0, 0, 2, 1.5))
discard ralphCol.addSolid(newCollisionSphere(0, -0.25, 5, 1.5))
ralphCol.setFromCollideMask(CollideMask.bit(0))
ralphCol.setIntoCollideMask(CollideMask.allOff())
ralphPusher.horizontal = true
ralphPusher.addCollider(ralphColNp, ralph)
cTrav.addCollider(ralphColNp, ralphPusher)

var
  ralphGroundRay = newCollisionRay()
  ralphGroundCol = newCollisionNode("ralphRay")
  ralphGroundColNp = ralph.attachNewNode(ralphGroundCol)
  ralphGroundHandler = newCollisionHandlerQueue()

ralphGroundRay.setOrigin(0, 0, 9)
ralphGroundRay.setDirection(0, 0, -1)
discard ralphGroundCol.addSolid(ralphGroundRay)
ralphGroundCol.setFromCollideMask(CollideMask.bit(0))
ralphGroundCol.setIntoCollideMask(CollideMask.allOff())
cTrav.addCollider(ralphGroundColNp, ralphGroundHandler)

var
  camGroundRay = newCollisionRay()
  camGroundCol = newCollisionNode("camRay")
  camGroundColNp = base.camera.attachNewNode(camGroundCol)
  camGroundHandler = newCollisionHandlerQueue()

camGroundRay.setOrigin(0, 0, 9)
camGroundRay.setDirection(0, 0, -1)
discard camGroundCol.addSolid(camGroundRay)
camGroundCol.setFromCollideMask(CollideMask.bit(0))
camGroundCol.setIntoCollideMask(CollideMask.allOff())
cTrav.addCollider(camGroundColNp, camGroundHandler)

# Uncomment this line to see the collision rays
#ralphColNp.show()
#camGroundColNp.show()

# Uncomment this line to show a visual representation of the
# collisions occuring
#cTrav.showCollisions(base.render)

# Create some lighting
var ambientLight = newAmbientLight("ambientLight")
ambientLight.setColor(initLVector4f(0.3, 0.3, 0.3, 1.0))
base.render.setLight(base.render.attachNewNode(ambientLight))

var directionalLight = newDirectionalLight("directionalLight")
directionalLight.setDirection(initLVector3f(-5, -5, -5))
directionalLight.setColor(initLVector4f(1))
directionalLight.setSpecularColor(initLVector4f(1))
base.render.setLight(base.render.attachNewNode(directionalLight))


# This is used to store which keys are currently pressed.
type
  Keys = enum
    left, right, forward, backward,
    cam_left, cam_right
  KeyMap = array[left..cam_right, bool]
var keyMap: KeyMap

# Records the state of the arrow keys
proc setKey(key: Keys, value: bool) =
  keyMap[key] = value


base.accept("escape", proc () = quit(0))
base.accept("arrow_left", proc () = setKey(left, true))
base.accept("arrow_right", proc () = setKey(right, true))
base.accept("arrow_up", proc () = setKey(forward, true))
base.accept("arrow_down", proc () = setKey(backward, true))
base.accept("a", proc () = setKey(cam_left, true))
base.accept("s", proc () = setKey(cam_right, true))

base.accept("arrow_left-up", proc () = setKey(left, false))
base.accept("arrow_right-up", proc () = setKey(right, false))
base.accept("arrow_up-up", proc () = setKey(forward, false))
base.accept("arrow_down-up", proc () = setKey(backward, false))
base.accept("a-up", proc () = setKey(cam_left, false))
base.accept("s-up", proc () = setKey(cam_right, false))

var currentAnim: string

# Accepts arrow keys to move either the player or the menu cursor,
# Also deals with grid checking and collision detection
proc move(task:Task): auto =
  var dt = base.clock.get_dt()
  if keyMap[cam_left]:
    base.camera.setX(base.camera, -20 * dt)
  if keyMap[cam_right]:
    base.camera.setX(base.camera, +20 * dt)
  # If a move-key is pressed, move ralph in the specified direction.
  if keyMap[left]:
    ralph.setH(ralph.getH() + 300 * dt)
  if keyMap[right]:
    ralph.setH(ralph.getH() - 300 * dt)
  if keyMap[forward]:
    ralph.setY(ralph, -20 * dt)
  if keyMap[backward]:
    ralph.setY(ralph, +10 * dt)

  # If ralph is moving, loop the run animation.
  # If he is standing still, stop the animation.
  currentAnim = ralph.getCurrentAnim()
  if currentAnim == "":
    currentAnim = "none"

  if keyMap[forward]:
    if currentAnim != "run":
      ralph.loop("run")
  elif keyMap[backward]:
    # Play the walk animation backwards.
    if currentAnim != "walk":
      ralph.loop("walk")
    ralph.setPlayRate(-1.0, "walk")
  elif keyMap[left] or keyMap[right]:
    if currentAnim != "walk":
      ralph.loop("walk")
    ralph.setPlayRate(1.0, "walk")
  else:
    ralph.stop("run")
    ralph.stop("walk")
    ralph.pose("walk", 5)

  var camvec = ralph.getPos() - base.camera.getPos()
  camvec.setZ(0)
  var camdist = camvec.length()
  discard camvec.normalize()
  if camdist > 10:
    base.camera.setPos(base.camera.getPos() + camvec * (camdist - 10))
    camdist = 10
  if camdist < 5.0:
    base.camera.setPos(base.camera.getPos() - camvec * (5 - camdist))
    camdist = 5.0
  # Normally, we would have to call traverse() to check for collisions.
  # However, the class ShowBase that we inherit from has a task to do
  # this for us, if we assign a CollisionTraverser to self.cTrav.
  cTrav.traverse(render)

  # Adjust ralph's Z coordinate.  If ralph's ray hit terrain,
  # update his Z

  ralphGroundHandler.sortEntries()
  var entry = ralphGroundHandler.getEntry(0)
  if entry.getIntoNode().name == "terrain":
    ralph.setZ(entry.getSurfacePoint(render).getZ())

  camGroundHandler.sortEntries()
  entry = camGroundHandler.getEntry(0)
  if entry.getIntoNode().name == "terrain":
    base.camera.setZ(entry.getSurfacePoint(render).getZ()+1.5)
  if base.camera.getZ() < ralph.getZ() + 2.0:
    base.camera.setZ(ralph.getZ() + 2.0)

  base.camera.lookAt(floater)
  Task.cont

base.taskMgr.add(move, "moveTask")
base.run()
