import std/time_t
export time_t.Time

when defined(pandaDir):
  const pandaDir* {.strdefine.}: string = ""
  when len(pandaDir) < 1:
    {.error: "pandaDir must not be an empty string when defined".}

when defined(vcc):
  {.passC: "/DNOMINMAX".}

  when defined(pandaDir):
    {.passC: "/I\"" & pandaDir & "/include\"".}

# For memcpy, Notify
{.emit: """
#include <cstring>
#include "pnotify.h"
""".}

const deconstifyCode* = """
#include "pointerTo.h"

template<class T> PT(T) deconstify(CPT(T) value) {
  PT(T) result;
  result.cheat() = (T *)value.p();
  value.cheat() = nullptr;
  return result;
}

template<class T> T *deconstify(const T *value) {
  return (T *)value;
}
""";

const stringConversionCode* = """
#include <string>

N_LIB_PRIVATE N_NIMCALL(std::string, nimStringToStdString)(struct NimStringDesc *desc);
N_LIB_PRIVATE N_NIMCALL(struct NimStringDesc*, nimStringFromStdString)(const std::string &s);
""";

type
  std_string* {.importcpp: "std::string", header: "string".} = object

type
  std_string_const_ref* {.importcpp: "std::string const&", header: "string".} = object

func size(this: std_string): int {.importcpp: "size".}
func size(this: std_string_const_ref): int {.importcpp: "size".}

func nimStringFromStdString(s: std_string_const_ref): string {.noinit, exportcpp: "nimStringFromStdString".} =
  result = newString(s.size())
  {.emit: "memcpy(result->data, s.data(), s.size());"}

func nimStringToStdString(desc: string): std_string {.noinit, exportcpp: "nimStringToStdString".} =
  {.emit: "if (desc != nullptr) result.assign(desc->data, desc->len);"}

when not defined(release):
  type
    const_char {.importcpp: "const char", nodecl.} = object

  func assertHandler(expression: ptr[const_char], line: cint, sourceFile: ptr[const_char]): bool {.exportcpp: "nimAssertHandler".} =
    var cmsg : std_string
    {.emit: [cmsg, " = Notify::ptr()->get_assert_error_message();"].}
    var msg = newString(cmsg.size())
    {.emit: ["memcpy(", msg, "->data, ", cmsg, ".data(), ", cmsg, ".size());"].}
    raiseAssert(msg)

  proc installAssertHandler() =
    {.emit: "Notify::ptr()->set_assert_handler(&nimAssertHandler);".}

  installAssertHandler()
