This is a proof of concept nim binding for Panda3D.

It currently accepts this code:
```nim
import direct/showbase
import panda3d/core

var base : ShowBase
base = ShowBase()
base.openDefaultWindow()

var env = loader.loadModel("models/environment")
env.reparentTo(render)

base.run()
```

Building the example:
```
make test
./test
```
