This is a proof of concept nim binding for Panda3D.

There is a subset of the DIRECT API implemented as well.  It is deliberately
incomplete, only the parts that can't be trivially reimplemented using the C++
API are intended to be supported.

Some things to keep in mind:
* Reference-counted types like PandaNode are always by-ref, using Panda's
  reference counting system, just like in Python.  To create an instance, use
  something like `newPandaNode()`.  These types are `nil`lable.
* Other types, like NodePath, are stored by-value.  Create instances using
  `initNodePath()` and the like.
* The typical code convention in nim is camelCase, but snake_case is supported
  as well by virtue of how nim's identifier resolution works.
* Both property interfaces and getter/setter methods are supported.
* Tuples are accepted in place of vectors, but be sure that the types of the
  elements are correct.
* The ShowBase constructor doesn't open a window.  Call `openDefaultWindow()`.
* The `direct` modules are woefully incomplete, see above.

Here is a brief example, see `test.nim` for the complete Hello World tutorial.
```nim
import direct/showbase
import direct/actor
import panda3d/core

var base = ShowBase()
base.openDefaultWindow()

var env = loader.loadModel("models/environment")
env.reparentTo(render)
env.setScale(0.25, 0.25, 0.25)
env.setPos(-8, 42, 0)

var pandaActor = Actor()
pandaActor.loadModel("models/panda-model")
pandaActor.loadAnims({"walk": "models/panda-walk4"})
pandaActor.setScale(0.005, 0.005, 0.005)
pandaActor.reparentTo(render)
pandaActor.loop("walk")

base.run()
```

Building the example:
```
make test
./test
```
