import ../panda3d/core

proc newGenericAsyncTask(name: cstring, function, user_data: pointer): AsyncTask {.cdecl, importcpp: "new GenericAsyncTask(@)", header: "genericAsyncTask.h"}

type
  TaskManager* = ref object of RootObj
    mgr: AsyncTaskManager
    running: bool

proc add*(this: TaskManager, function: (proc(): int), name: string, sort: int = 0) : AsyncTask {.discardable.} =
  var task = newGenericAsyncTask(name, rawProc(function), rawEnv(function))
  AsyncTaskManager.getGlobalPtr().add(task)
  return task

proc stop*(this: TaskManager) =
  this.running = false

proc run*(this: TaskManager) =
  this.running = true
  while this.running:
    this.mgr.poll()

var taskMgr* = TaskManager()
taskMgr.mgr = AsyncTaskManager.getGlobalPtr()
