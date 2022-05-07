import direct/showbase
import direct/task
import panda3d/core
import std/math

var base = ShowBase()
base.openDefaultWindow()

var env = loader.loadModel("models/environment")
env.reparentTo(render)
env.setScale(0.25, 0.25, 0.25)
env.setPos(-8, 42, 0)

proc spinCameraTask(task: Task): auto =
  var angleDegrees = task.time * 6.0
  var angleRadians = angleDegrees * (PI / 180.0)
  base.camera.setPos(20 * sin(angleRadians), -20 * cos(angleRadians), 3)
  base.camera.setHpr(angleDegrees, 0, 0)
  Task.cont

base.taskMgr.add(spinCameraTask, "SpinCameraTask")

base.run()
