import direct/showbase
import panda3d/core

var base : ShowBase
base = ShowBase()
base.openDefaultWindow()

var env = base.loader.loadModel("models/environment")
env.reparentTo(base.render)

base.run()
