import ../../panda3d/core
import std/tables

type
  DirectObject* = ref object of RootObj
    messengerId: int

type
  Messenger* = ref object of RootObj
    callbacks: Table[string, Table[int, proc (args: openArray[EventParameter])]]

var nextMessengerId = 1

proc accept*(this: Messenger, event: string, obj: DirectObject, function: proc ()) =
  var acceptorDict = addr this.callbacks.mgetOrPut(event, Table[int, proc (args: openArray[EventParameter])]())
  if obj.messengerId == 0:
    obj.messengerId = nextMessengerId
    nextMessengerId += 1

  acceptorDict[][obj.messengerId] = (proc(args: openArray[EventParameter]) = function())

proc accept*[T](this: Messenger, event: string, obj: DirectObject, function: proc (param: T)) =
  var acceptorDict = addr this.callbacks.mgetOrPut(event, Table[int, proc (args: openArray[EventParameter])]())
  if obj.messengerId == 0:
    obj.messengerId = nextMessengerId
    nextMessengerId += 1

  acceptorDict[][obj.messengerId] = (proc(args: openArray[EventParameter]) = function(T.dcast(args[0].getPtr())))

proc send*(this: Messenger, event: string, sentArgs: openArray[EventParameter] = []) =
  if this.callbacks.hasKey(event):
    var acceptorDict = this.callbacks.getOrDefault(event)
    for function in acceptorDict.values:
      function(sentArgs)
