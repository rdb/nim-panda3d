import ../panda3d/core
import ../panda3d/direct

export direct

var lerpNodePathNum = 1
var sequenceNum = 1
var parallelNum = 1
var funcNum = 1

proc posInterval*(nodePath: NodePath, duration: float, pos: VBase3, startPos: VBase3): CLerpNodePathInterval =
  let num = lerpNodePathNum
  lerpNodePathNum += 1
  var ival = newCLerpNodePathInterval("LerpPosInterval-" & $num, duration, CLerpInterval.BTNoBlend, true, false, nodePath, initNodePath())
  ival.setStartPos(startPos)
  ival.setEndPos(pos)
  return ival

proc hprInterval*(nodePath: NodePath, duration: float, hpr: VBase3, startHpr: VBase3): CLerpNodePathInterval =
  let num = lerpNodePathNum
  lerpNodePathNum += 1
  var ival = newCLerpNodePathInterval("LerpHprInterval-" & $num, duration, CLerpInterval.BTNoBlend, true, false, nodePath, initNodePath())
  ival.setStartHpr(startHpr)
  ival.setEndHpr(hpr)
  return ival

proc Sequence*(ivals: varargs[CInterval], name: string = ""): CMetaInterval =
  let num = sequenceNum
  sequenceNum += 1
  var meta = newCMetaInterval("Sequence-" & $num)
  for ival in ivals:
    discard meta.addCInterval(ival, 0, CMetaInterval.RSPreviousEnd)
  return meta

proc Parallel*(ivals: varargs[CInterval], name: string = ""): CMetaInterval =
  let num = parallelNum
  parallelNum += 1
  var meta = newCMetaInterval("Parallel-" & $num)
  for ival in ivals:
    discard meta.addCInterval(ival, 0, CMetaInterval.RSLevelBegin)
  return meta

proc Wait*(duration: float): WaitInterval =
  return newWaitInterval(duration)

{.emit: """/*TYPESECTION*/
#include "cInterval.h"

N_LIB_PRIVATE N_NIMCALL(void, unrefEnv)(void *envp);

class NimFunctionInterval final : public CInterval {
public:
  typedef void Function(void *env);

  NimFunctionInterval(const std::string &name, Function *proc, void *env) :
    CInterval(name, 0.0, true),
    _proc(proc),
    _env(env) {}

  virtual ~NimFunctionInterval() {
    if (_env != nullptr) {
      unrefEnv(_env);
    }
  }

  virtual void priv_instant() override {
    _proc(_env);
  }

private:
  Function *_proc;
  void *_env;
};
""".}

proc Func*(function: proc()): CInterval =
  var procp = rawProc(function);
  var envp = rawEnv(function);
  if envp != nil:
    GC_ref(cast[RootRef](envp))

  let num = funcNum
  funcNum += 1
  let name: string = "Func-" & $num

  {.emit: """
  std::string cname;
  if (name != nullptr) {
    cname.assign(`name`->data, `name`->len);
  }
  `result` = new NimFunctionInterval(cname, (NimFunctionInterval::Function *)`procp`, `envp`);
  """.}

template Func*[T1](function: proc(arg1: T1), arg1: T1): CInterval =
  Func(proc() = function(arg1))

template Func*[T1, T2](function: proc(arg1: T1, arg2: T2), arg1: T1, arg2: T2): CInterval =
  Func(proc() = function(arg1, arg2))

template Func*[T1, T2, T3](function: proc(arg1: T1, arg2: T2, arg3: T3), arg1: T1, arg2: T2, arg3: T3): CInterval =
  Func(proc() = function(arg1, arg2, arg3))

template Func*[T1, T2, T3, T4](function: proc(arg1: T1, arg2: T2, arg3: T3, arg4: T4), arg1: T1, arg2: T2, arg3: T3, arg4: T4): CInterval =
  Func(proc() = function(arg1, arg2, arg3, arg4))

template Func*[T1, T2, T3, T4, T5](function: proc(arg1: T1, arg2: T2, arg3: T3, arg4: T4, arg5: T5), arg1: T1, arg2: T2, arg3: T3, arg4: T4, arg5: T5): CInterval =
  Func(proc() = function(arg1, arg2, arg3, arg4, arg5))
