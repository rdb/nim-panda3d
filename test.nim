import direct/showbase
import direct/task
import direct/actor
import panda3d/core
import std/math

var base = ShowBase()
base.openDefaultWindow()

var env = base.loader.loadModel("models/environment")
env.reparentTo(base.render)
env.setScale(0.25, 0.25, 0.25)
env.setPos(-8, 42, 0)

var pandaActor = Actor()
pandaActor.loadModel("models/panda-model")
pandaActor.loadAnims({"walk": "models/panda-walk4"})
pandaActor.setScale(0.005, 0.005, 0.005)
pandaActor.reparentTo(render)
pandaActor.loop("walk")

proc spinCameraTask(task: Task): auto =
  var angleDegrees = task.time * 6.0
  var angleRadians = angleDegrees * (PI / 180.0)
  base.camera.setPos(20 * sin(angleRadians), -20 * cos(angleRadians), 3)
  base.camera.setHpr(angleDegrees, 0, 0)
  Task.cont

base.taskMgr.add(spinCameraTask, "SpinCameraTask")

base.run()
