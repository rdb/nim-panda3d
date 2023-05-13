import std/time_t
export time_t.Time

from os import splitPath

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

const deconstifyCode* = "#include \"" & currentSourcePath().splitPath.head & "/helpers.hpp\"";

when defined(nimSeqsV2):
  const stringConversionCode* = """
#include <string>

N_LIB_PRIVATE N_NIMCALL(std::string, nimStringToStdString)(struct NimStringV2 desc);
N_LIB_PRIVATE N_NIMCALL(struct NimStringV2, nimStringFromStdString)(const std::string &s);
""";
else:
  const stringConversionCode* = """
#include <string>

N_LIB_PRIVATE N_NIMCALL(std::string, nimStringToStdString)(struct NimStringDesc *desc);
N_LIB_PRIVATE N_NIMCALL(struct NimStringDesc*, nimStringFromStdString)(const std::string &s);
""";

type
  std_string* {.importcpp: "std::string", header: "string".} = object

type
  std_string_const_ref* {.importcpp: "std::string const&", header: "string".} = object

converter constRef(s: std_string): std_string_const_ref {.importcpp: "(#)".}

func size(this: std_string_const_ref): int {.importcpp: "size".}

when defined(nimSeqsV2):
  func nimStringFromStdString(s: std_string_const_ref): string {.noinit, exportcpp: "nimStringFromStdString".} =
    result = newString(s.size())
    {.emit: "memcpy(result.p->data, `s`.data(), `s`.size());"}

  func nimStringToStdString(desc: string): std_string {.noinit, exportcpp: "nimStringToStdString".} =
    {.emit: "if (`desc`.len > 0) result.assign(`desc`.p->data, `desc`.len);"}
else:
  func nimStringFromStdString(s: std_string_const_ref): string {.noinit, exportcpp: "nimStringFromStdString".} =
    result = newString(s.size())
    {.emit: "memcpy(result->data, `s`.data(), `s`.size());"}

  func nimStringToStdString(desc: string): std_string {.noinit, exportcpp: "nimStringToStdString".} =
    {.emit: "if (`desc` != nullptr) result.assign(`desc`->data, `desc`->len);"}

proc unrefEnv(envp: pointer) {.noinit, exportcpp: "unrefEnv".} =
  GC_unref(cast[RootRef](envp))

when not defined(release):
  type
    const_char {.importcpp: "const char", nodecl.} = object

  func assertHandler(expression: ptr[const_char], line: cint, sourceFile: ptr[const_char]): bool {.exportcpp: "nimAssertHandler".} =
    var cmsg : std_string
    {.emit: [cmsg, " = Notify::ptr()->get_assert_error_message();"].}
    raiseAssert(nimStringFromStdString(cmsg))

  proc installAssertHandler() =
    {.emit: "Notify::ptr()->set_assert_handler(&nimAssertHandler);".}

  installAssertHandler()
