import std/tables

type
  DirectObject* = ref object of RootObj
    messengerId: int

type
  Messenger* = ref object of RootObj
    callbacks: Table[string, Table[int, proc ()]]

var nextMessengerId = 1

proc accept*(this: Messenger, event: string, obj: DirectObject, function: proc ()) =
  var acceptorDict = addr this.callbacks.mgetOrPut(event, Table[int, proc ()]())
  if obj.messengerId == 0:
    obj.messengerId = nextMessengerId
    nextMessengerId += 1

  acceptorDict[][obj.messengerId] = function

proc send*(this: Messenger, event: string) =
  if this.callbacks.hasKey(event):
    var acceptorDict = this.callbacks.getOrDefault(event)
    for function in acceptorDict.values:
      function()
