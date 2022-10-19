import direct/showbase
import direct/task
import direct/actor
import direct/interval
import panda3d/core
import std/math

var base = ShowBase()
base.openDefaultWindow()
base.disableMouse()

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

# Create the four lerp intervals needed for the panda to
# walk back and forth.
var posInterval1 = pandaActor.posInterval(13,
                                          (0, -10, 0),
                                          startPos=(0, 10, 0))
var posInterval2 = pandaActor.posInterval(13,
                                          (0, 10, 0),
                                          startPos=(0, -10, 0))
var hprInterval1 = pandaActor.hprInterval(3,
                                          (180, 0, 0),
                                          startHpr=(0, 0, 0))
var hprInterval2 = pandaActor.hprInterval(3,
                                          (0, 0, 0),
                                          startHpr=(180, 0, 0))

# Create and play the sequence that coordinates the intervals.
var pandaPace = Sequence(posInterval1, hprInterval1,
                         posInterval2, hprInterval2,
                         name="pandaPace")
pandaPace.loop()

proc spinCameraTask(task: Task): auto =
  var angleDegrees = task.time * 6.0
  var angleRadians = angleDegrees * (PI / 180.0)
  base.camera.setPos(20 * sin(angleRadians), -20 * cos(angleRadians), 3)
  base.camera.setHpr(angleDegrees, 0, 0)
  Task.cont

base.taskMgr.add(spinCameraTask, "SpinCameraTask")

base.run()
