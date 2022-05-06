This is a proof of concept nim binding for Panda3D.

It currently accepts this code:
```nim
import direct/showbase
import panda3d/core

var base = ShowBase()
base.openDefaultWindow()

var env = loader.loadModel("models/environment")
env.reparentTo(render)
env.setScale(0.25, 0.25, 0.25)
env.setPos(-8, 42, 0)

base.run()
```

Building the example:
```
make test
./test
```
