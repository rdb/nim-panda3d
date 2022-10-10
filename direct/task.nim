import ../panda3d/core

{.emit: """/*TYPESECTION*/
#include "asyncTask.h"

class NimTask final : public AsyncTask {
public:
  typedef int TaskProc(PT(AsyncTask) task, void *env);

  NimTask(TaskProc *proc, void *env) : _proc(proc), _env(env) {}
  virtual ~NimTask();

  ALLOC_DELETED_CHAIN(NimTask);

  virtual DoneStatus do_task() {
    return (DoneStatus)_proc(this, _env);
  }

private:
  TaskProc *_proc;
  void *_env;
};
""".}

proc unrefEnv(envp: pointer) {.noinit, exportcpp: "unrefEnv".} =
  GC_unref(cast[RootRef](envp))

{.emit: """
NimTask::~NimTask() {
  if (_env != nullptr) {
    unrefEnv(_env);
  }
}
""".}

type
  Task* = AsyncTask

type
  DoneStatus {.pure.} = enum
    done = 0
    cont = 1
    again = 2
    pickup = 3
    exit = 4

template done*(_: typedesc[Task]): DoneStatus =
  DoneStatus.done

template cont*(_: typedesc[Task]): DoneStatus =
  DoneStatus.cont

template again*(_: typedesc[Task]): DoneStatus =
  DoneStatus.again

template pickup*(_: typedesc[Task]): DoneStatus =
  DoneStatus.pickup

template exit*(_: typedesc[Task]): DoneStatus =
  DoneStatus.exit

type
  TaskManager* = ref object of RootObj
    mgr: AsyncTaskManager
    running: bool

proc add*(this: TaskManager, function: (proc(task: Task): DoneStatus), name: string, sort: int = 0) : AsyncTask {.discardable.} =
  var procp = rawProc(function);
  var envp = rawEnv(function);
  if envp != nil:
    GC_ref(cast[RootRef](envp))

  {.emit: """
  `result` = new NimTask((NimTask::TaskProc *)`procp`, `envp`);
  `this`->mgr->add(`result`.p());
  """.}

proc stop*(this: TaskManager) =
  this.running = false

proc run*(this: TaskManager) =
  this.running = true
  while this.running:
    this.mgr.poll()

var taskMgr* = new(TaskManager)
taskMgr.mgr = AsyncTaskManager.getGlobalPtr()
