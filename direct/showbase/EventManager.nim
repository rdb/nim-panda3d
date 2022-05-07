import ../../panda3d/core
import ../task
import ./Messenger
import ./MessengerGlobal

type
  EventManager* = ref object of RootObj
    eventQueue*: EventQueue

proc processEvent*(this: EventManager, event: Event) =
  messenger.send(event.name)

proc doEvents*(this: EventManager) =
  while not this.eventQueue.isQueueEmpty():
    this.processEvent(this.eventQueue.dequeueEvent())

proc eventLoopTask(this: EventManager, task: Task): auto =
  this.doEvents()
  Task.cont

proc restart*(this: EventManager) =
  taskMgr.add(proc (task: Task): auto = this.eventLoopTask(task), "eventManager")
