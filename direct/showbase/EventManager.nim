import ../../panda3d/core
import ../task
import ./Messenger
import ./MessengerGlobal

type
  EventManager* = ref object of RootObj
    eventQueue*: EventQueue

proc doEvents*(this: EventManager) =
  while not this.eventQueue.isQueueEmpty():
    var event = this.eventQueue.dequeueEvent()
    var numParams = event.getNumParameters()
    var parameters = newSeq[EventParameter](numParams)

    for i in 0..numParams-1:
      parameters[i] = event.getParameter(i)

    messenger.send(event.name, parameters)

proc eventLoopTask(this: EventManager, task: Task): auto =
  this.doEvents()
  Task.cont

proc restart*(this: EventManager) =
  taskMgr.add(proc (task: Task): auto = this.eventLoopTask(task), "eventManager")
