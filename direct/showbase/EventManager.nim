import ../../panda3d/core
import ../task
import ./Messenger
import ./MessengerGlobal

type
  EventManager* = ref object of RootObj
    eventQueue*: EventQueue

proc doEvents*(this: EventManager) =
  while not this.eventQueue.isQueueEmpty():
    messenger.send(this.eventQueue.dequeueEvent().name)

proc eventLoopTask(this: EventManager, task: Task): auto =
  this.doEvents()
  Task.cont

proc restart*(this: EventManager) =
  taskMgr.add(proc (task: Task): auto = this.eventLoopTask(task), "eventManager")
