__all__ = []

import os, sys
from distutils import sysconfig
import pathlib
import panda3d, pandac
from panda3d.interrogatedb import *


if 'interrogate_element_is_sequence' not in globals():
    def interrogate_element_is_sequence(element):
        return False

if 'interrogate_element_is_mapping' not in globals():
    def interrogate_element_is_mapping(element):
        return False

if 'interrogate_type_is_final' not in globals():
    def interrogate_type_is_final(type):
        return False

if 'interrogate_function_is_constructor' not in globals():
    def interrogate_function_is_constructor(func):
        return interrogate_function_is_method(func) and \
            interrogate_function_name(func) == interrogate_type_name(interrogate_function_class(func))

if 'interrogate_function_is_destructor' not in globals():
    def interrogate_function_is_destructor(func):
        return interrogate_function_name(func).startswith('~')

if 'interrogate_wrapper_parameter_is_optional' not in globals():
    def interrogate_wrapper_parameter_parameter_is_optional(wrapper):
        return False

if 'interrogate_wrapper_is_copy_constructor' not in globals():
    def interrogate_wrapper_is_copy_constructor(wrapper):
        if interrogate_wrapper_number_of_parameters(wrapper) != 1 or \
           interrogate_wrapper_parameter_is_this(wrapper, 0):
            return False

        param_type = interrogate_wrapper_parameter_type(wrapper, 0)
        while interrogate_type_is_wrapped(param_type) or interrogate_type_is_typedef(param_type):
            param_type = interrogate_type_wrapped_type(param_type)

        if not interrogate_type_is_class(param_type) and not interrogate_type_is_struct(param_type):
            return False

        for i_ctor in range(interrogate_type_number_of_constructors(param_type)):
            ctor = interrogate_type_get_constructor(param_type, i_ctor)
            for i_wrap in range(interrogate_function_number_of_python_wrappers(ctor)):
                if interrogate_function_python_wrapper(ctor, i_wrap) == wrapper:
                    return True

        return False

if 'interrogate_wrapper_is_coerce_constructor' not in globals():
    def interrogate_wrapper_is_coerce_constructor(wrapper):
        return False


CORE_PREAMBLE = """
import ./private

when defined(vcc):
  when defined(pandaDir):
    {.passL: "\\"" & pandaDir & "/lib/libpandaexpress.lib\\"".}
    {.passL: "\\"" & pandaDir & "/lib/libpanda.lib\\"".}
    {.passL: "\\"" & pandaDir & "/lib/libp3dtoolconfig.lib\\"".}
    {.passL: "\\"" & pandaDir & "/lib/libp3dtool.lib\\"".}
  else:
    {.passL: "libpandaexpress.lib libpanda.lib libp3dtoolconfig.lib libp3dtool.lib".}

else:
  {.passL: "-lpandaexpress -lpanda -lp3dtoolconfig -lp3dtool".}

const wrappedVec2Code = \"\"\"
#include "lvecBase2.h"
#include "lvector2.h"
#include "lpoint2.h"

template<class T>
struct alignas(T) WrappedVBase2 {
  typename T::numeric_type x;
  typename T::numeric_type y;

  constexpr WrappedVBase2() = default;
  WrappedVBase2(typename T::numeric_type v0, typename T::numeric_type v1) : x(v0), y(v1) { }
  WrappedVBase2(const T &v) : x(v[0]), y(v[1]) { }
  operator const T &() const { return *(const T *)this; }
  operator T &() { return *(T *)this; }
};

template<class T, class B>
struct alignas(T) WrappedVec2 : public WrappedVBase2<B> {
  constexpr WrappedVec2() = default;
  WrappedVec2(typename T::numeric_type v0, typename T::numeric_type v1) : WrappedVBase2<B>(v0, v1) { }
  WrappedVec2(const T &v) : WrappedVBase2<B>(v[0], v[1]) { }
  operator const T &() const { return *(const T *)this; }
  operator T &() { return *(T *)this; }
};

typedef WrappedVBase2<LVecBase2f> WrappedLVecBase2f;
typedef WrappedVBase2<LVecBase2d> WrappedLVecBase2d;
typedef WrappedVBase2<LVecBase2i> WrappedLVecBase2i;
typedef WrappedVec2<LVector2f, LVecBase2f> WrappedLVector2f;
typedef WrappedVec2<LVector2f, LVecBase2d> WrappedLVector2d;
typedef WrappedVec2<LVector2f, LVecBase2i> WrappedLVector2i;
typedef WrappedVec2<LPoint2f, LVecBase2f> WrappedLPoint2f;
typedef WrappedVec2<LPoint2f, LVecBase2d> WrappedLPoint2d;
typedef WrappedVec2<LPoint2f, LVecBase2i> WrappedLPoint2i;
\"\"\";

const wrappedVec3Code = \"\"\"
#include "lvecBase3.h"
#include "lvector3.h"
#include "lpoint3.h"

template<class T>
struct alignas(T) WrappedVBase3 {
  typename T::numeric_type x = 0;
  typename T::numeric_type y = 0;
  typename T::numeric_type z = 0;

  constexpr WrappedVBase3() = default;
  WrappedVBase3(typename T::numeric_type v0, typename T::numeric_type v1, typename T::numeric_type v2) : x(v0), y(v1), z(v2) { }
  WrappedVBase3(const T &v) : x(v[0]), y(v[1]), z(v[2]) { }
  operator const T &() const { return *(const T *)this; }
  operator T &() { return *(T *)this; }
};

template<class T, class B>
struct alignas(T) WrappedVec3 : public WrappedVBase3<B> {
  constexpr WrappedVec3() = default;
  WrappedVec3(typename T::numeric_type v0, typename T::numeric_type v1, typename T::numeric_type v2) : WrappedVBase3<B>(v0, v1, v2) { }
  WrappedVec3(const T &v) : WrappedVBase3<B>(v[0], v[1], v[2]) { }
  operator const T &() const { return *(const T *)this; }
  operator T &() { return *(T *)this; }
};

typedef WrappedVBase3<LVecBase3f> WrappedLVecBase3f;
typedef WrappedVBase3<LVecBase3d> WrappedLVecBase3d;
typedef WrappedVBase3<LVecBase3i> WrappedLVecBase3i;
typedef WrappedVec3<LVector3f, LVecBase3f> WrappedLVector3f;
typedef WrappedVec3<LVector3f, LVecBase3d> WrappedLVector3d;
typedef WrappedVec3<LVector3f, LVecBase3i> WrappedLVector3i;
typedef WrappedVec3<LPoint3f, LVecBase3f> WrappedLPoint3f;
typedef WrappedVec3<LPoint3f, LVecBase3d> WrappedLPoint3d;
typedef WrappedVec3<LPoint3f, LVecBase3i> WrappedLPoint3i;
\"\"\";

const wrappedVec4Code = \"\"\"
#include "lvecBase4.h"
#include "lvector4.h"
#include "lpoint4.h"

template<class T>
struct alignas(T) WrappedVBase4 {
  typename T::numeric_type x = 0;
  typename T::numeric_type y = 0;
  typename T::numeric_type z = 0;
  typename T::numeric_type w = 0;

  constexpr WrappedVBase4() = default;
  WrappedVBase4(typename T::numeric_type v0, typename T::numeric_type v1, typename T::numeric_type v2, typename T::numeric_type v3) : x(v0), y(v1), z(v2), w(v3) { }
  WrappedVBase4(const T &v) : x(v[0]), y(v[1]), z(v[2]), w(v[3]) { }
  operator const T &() const { return *(const T *)this; }
  operator T &() { return *(T *)this; }
};

template<class T, class B>
struct alignas(T) WrappedVec4 : public WrappedVBase4<B> {
  constexpr WrappedVec4() = default;
  WrappedVec4(typename T::numeric_type v0, typename T::numeric_type v1, typename T::numeric_type v2, typename T::numeric_type v3) : WrappedVBase4<B>(v0, v1, v2, v3) { }
  WrappedVec4(const T &v) : WrappedVBase4<B>(v[0], v[1], v[2], v[3]) { }
  operator const T &() const { return *(const T *)this; }
  operator T &() { return *(T *)this; }
};

typedef WrappedVBase4<LVecBase4f> WrappedLVecBase4f;
typedef WrappedVBase4<LVecBase4d> WrappedLVecBase4d;
typedef WrappedVBase4<LVecBase4i> WrappedLVecBase4i;
typedef WrappedVec4<LVector4f, LVecBase4f> WrappedLVector4f;
typedef WrappedVec4<LVector4f, LVecBase4d> WrappedLVector4d;
typedef WrappedVec4<LVector4f, LVecBase4i> WrappedLVector4i;
typedef WrappedVec4<LPoint4f, LVecBase4f> WrappedLPoint4f;
typedef WrappedVec4<LPoint4f, LVecBase4d> WrappedLPoint4d;
typedef WrappedVec4<LPoint4f, LVecBase4i> WrappedLPoint4i;
\"\"\";

"""

CORE_POSTAMBLE = """
converter initFilename*(fn: string): Filename {.importcpp: "Filename(([](NimStringDesc *desc) {return std::string(desc->data, desc->len);})(#))".}

converter toInternalName*(name: string): InternalName {.importcpp: "InternalName::make(nimStringToStdString(#))", header: "internalName.h".}

proc setText*(this: TextEncoder, text: string) {.importcpp: "#->set_text(nimStringToStdString(#))", header: stringConversionCode.}
func text*(this: TextEncoder) : string {.importcpp: "nimStringFromStdString(#->get_text())", header: stringConversionCode.}
func `text=`*(this: TextEncoder, text: string) {.importcpp: "#->set_text(nimStringToStdString(#))", header: stringConversionCode.}

func time*(this: AsyncTask): float {.importcpp: "#->get_elapsed_time()".}

func initLVecBase2f*(): LVecBase2f = LVecBase2f(x: 0, y: 0)
func initLVecBase2f*(copy: LVecBase2f): LVecBase2f = LVecBase2f(x: copy.x, y: copy.y)
func initLVecBase2f*(fill_value: float32): LVecBase2f = LVecBase2f(x: fill_value, y: fill_value)
func initLVecBase2f*(x: float32, y: float32): LVecBase2f = LVecBase2f(x: x, y: y)
converter initLVecBase2f*[T0, T1: SomeNumber](args: tuple[x: T0, y: T1]): LVecBase2f {.inline, noSideEffect.} = LVecBase2f(x: (float32)args.x, y: (float32)args.y)

func initLVecBase2d*(): LVecBase2d = LVecBase2d(x: 0, y: 0)
func initLVecBase2d*(copy: LVecBase2d): LVecBase2d = LVecBase2d(x: copy.x, y: copy.y)
func initLVecBase2d*(fill_value: float64): LVecBase2d = LVecBase2d(x: fill_value, y: fill_value)
func initLVecBase2d*(x: float64, y: float64): LVecBase2d = LVecBase2d(x: x, y: y)
converter initLVecBase2d*[T0, T1: SomeNumber](args: tuple[x: T0, y: T1]): LVecBase2d {.inline, noSideEffect.} = LVecBase2d(x: (float64)args.x, y: (float64)args.y)

func initLVecBase2i*(): LVecBase2i = LVecBase2i(x: 0, y: 0)
func initLVecBase2i*(copy: LVecBase2i): LVecBase2i = LVecBase2i(x: copy.x, y: copy.y)
func initLVecBase2i*(fill_value: int32): LVecBase2i = LVecBase2i(x: fill_value, y: fill_value)
func initLVecBase2i*(x: int32, y: int32): LVecBase2i = LVecBase2i(x: x, y: y)
converter initLVecBase2i*[T0, T1: int | int32](args: tuple[x: T0, y: T1]): LVecBase2i {.inline, noSideEffect.} = LVecBase2i(x: (int32)args.x, y: (int32)args.y)

func initLVecBase3f*(): LVecBase3f = LVecBase3f(x: 0, y: 0, z: 0)
func initLVecBase3f*(copy: LVecBase2f, z: float32): LVecBase3f = LVecBase3f(x: copy.x, y: copy.y, z: z)
func initLVecBase3f*(copy: LVecBase3f): LVecBase3f = LVecBase3f(x: copy.x, y: copy.y, z: copy.z)
func initLVecBase3f*(fill_value: float32): LVecBase3f = LVecBase3f(x: fill_value, y: fill_value, z: fill_value)
func initLVecBase3f*(x: float32, y: float32, z: float32): LVecBase3f = LVecBase3f(x: x, y: y, z: z)
converter initLVecBase3f*[T0, T1, T2: SomeNumber](args: tuple[x: T0, y: T1, z: T2]): LVecBase3f {.inline, noSideEffect.} = LVecBase3f(x: (float32)args.x, y: (float32)args.y, z: (float32)args.z)

func initLVecBase3d*(): LVecBase3d = LVecBase3d(x: 0, y: 0, z: 0)
func initLVecBase3d*(copy: LVecBase2d, z: float64): LVecBase3d = LVecBase3d(x: copy.x, y: copy.y, z: z)
func initLVecBase3d*(copy: LVecBase3d): LVecBase3d = LVecBase3d(x: copy.x, y: copy.y, z: copy.z)
func initLVecBase3d*(fill_value: float64): LVecBase3d = LVecBase3d(x: fill_value, y: fill_value, z: fill_value)
func initLVecBase3d*(x: float64, y: float64, z: float64): LVecBase3d = LVecBase3d(x: x, y: y, z: z)
converter initLVecBase3d*[T0, T1, T2: SomeNumber](args: tuple[x: T0, y: T1, z: T2]): LVecBase3d {.inline, noSideEffect.} = LVecBase3d(x: (float64)args.x, y: (float64)args.y, z: (float64)args.z)

func initLVecBase3i*(): LVecBase3i = LVecBase3i(x: 0, y: 0, z: 0)
func initLVecBase3i*(copy: LVecBase2i, z: int32): LVecBase3i = LVecBase3i(x: copy.x, y: copy.y, z: z)
func initLVecBase3i*(copy: LVecBase3i): LVecBase3i = LVecBase3i(x: copy.x, y: copy.y, z: copy.z)
func initLVecBase3i*(fill_value: int32): LVecBase3i = LVecBase3i(x: fill_value, y: fill_value, z: fill_value)
func initLVecBase3i*(x: int32, y: int32, z: int32): LVecBase3i = LVecBase3i(x: x, y: y, z: z)
converter initLVecBase3i*[T0, T1, T2: int | int32](args: tuple[x: T0, y: T1, z: T2]): LVecBase3i {.inline, noSideEffect.} = LVecBase3i(x: (int32)args.x, y: (int32)args.y, z: (int32)args.z)

func initLVecBase4f*(): LVecBase4f = LVecBase4f(x: 0, y: 0, z: 0, w: 0)
func initLVecBase4f*(copy: LVecBase3f, w: float32): LVecBase4f = LVecBase4f(x: copy.x, y: copy.y, z: copy.z, w: w)
func initLVecBase4f*(copy: LVecBase4f): LVecBase4f = LVecBase4f(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
func initLVecBase4f*(fill_value: float32): LVecBase4f = LVecBase4f(x: fill_value, y: fill_value, z: fill_value, w: fill_value)
func initLVecBase4f*(x: float32, y: float32, z: float32, w: float32): LVecBase4f = LVecBase4f(x: x, y: y, z: z, w: w)
converter initLVecBase4f*[T0, T1, T2, T3: SomeNumber](args: tuple[x: T0, y: T1, z: T2, w: T3]): LVecBase4f {.inline, noSideEffect.} = LVecBase4f(x: (float32)args.x, y: (float32)args.y, z: (float32)args.z, w: (float32)args.w)
converter initLVecBase4f*(copy: UnalignedLVecBase4f): LVecBase4f = LVecBase4f(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
converter initLVecBase4f*(point: LPoint3f): LVecBase4f = LVecBase4f(x: point.x, y: point.y, z: point.z, w: 1)
converter initLVecBase4f*(vector: LVector3f): LVecBase4f = LVecBase4f(x: vector.x, y: vector.y, z: vector.z, w: 0)

func initLVecBase4d*(): LVecBase4d = LVecBase4d(x: 0, y: 0, z: 0, w: 0)
func initLVecBase4d*(copy: LVecBase3d, w: float64): LVecBase4d = LVecBase4d(x: copy.x, y: copy.y, z: copy.z, w: w)
func initLVecBase4d*(copy: LVecBase4d): LVecBase4d = LVecBase4d(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
func initLVecBase4d*(fill_value: float64): LVecBase4d = LVecBase4d(x: fill_value, y: fill_value, z: fill_value, w: fill_value)
func initLVecBase4d*(x: float64, y: float64, z: float64, w: float64): LVecBase4d = LVecBase4d(x: x, y: y, z: z, w: w)
converter initLVecBase4d*[T0, T1, T2, T3: SomeNumber](args: tuple[x: T0, y: T1, z: T2, w: T3]): LVecBase4d {.inline, noSideEffect.} = LVecBase4d(x: (float64)args.x, y: (float64)args.y, z: (float64)args.z, w: (float64)args.w)
converter initLVecBase4d*(copy: UnalignedLVecBase4d): LVecBase4d = LVecBase4d(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
converter initLVecBase4d*(point: LPoint3d): LVecBase4d = LVecBase4d(x: point.x, y: point.y, z: point.z, w: 1)
converter initLVecBase4d*(vector: LVector3d): LVecBase4d = LVecBase4d(x: vector.x, y: vector.y, z: vector.z, w: 0)

func initLVecBase4i*(): LVecBase4i = LVecBase4i(x: 0, y: 0, z: 0, w: 0)
func initLVecBase4i*(copy: LVecBase3i, w: int32): LVecBase4i = LVecBase4i(x: copy.x, y: copy.y, z: copy.z, w: w)
func initLVecBase4i*(copy: LVecBase4i): LVecBase4i = LVecBase4i(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
func initLVecBase4i*(fill_value: int32): LVecBase4i = LVecBase4i(x: fill_value, y: fill_value, z: fill_value, w: fill_value)
func initLVecBase4i*(x: int32, y: int32, z: int32, w: int32): LVecBase4i = LVecBase4i(x: x, y: y, z: z, w: w)
converter initLVecBase4i*[T0, T1, T2, T3: int | int32](args: tuple[x: T0, y: T1, z: T2, w: T3]): LVecBase4i {.inline, noSideEffect.} = LVecBase4i(x: (int32)args.x, y: (int32)args.y, z: (int32)args.z, w: (int32)args.w)
converter initLVecBase4i*(copy: UnalignedLVecBase4i): LVecBase4i = LVecBase4i(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
converter initLVecBase4i*(point: LPoint3i): LVecBase4i = LVecBase4i(x: point.x, y: point.y, z: point.z, w: 1)
converter initLVecBase4i*(vector: LVector3i): LVecBase4i = LVecBase4i(x: vector.x, y: vector.y, z: vector.z, w: 0)

func initUnalignedLVecBase4f*(): UnalignedLVecBase4f = UnalignedLVecBase4f(x: 0, y: 0, z: 0, w: 0)
func initUnalignedLVecBase4f*(copy: UnalignedLVecBase4f): UnalignedLVecBase4f = UnalignedLVecBase4f(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
func initUnalignedLVecBase4f*(fill_value: float32): UnalignedLVecBase4f = UnalignedLVecBase4f(x: fill_value, y: fill_value, z: fill_value, w: fill_value)
func initUnalignedLVecBase4f*(x: float32, y: float32, z: float32, w: float32): UnalignedLVecBase4f = UnalignedLVecBase4f(x: x, y: y, z: z, w: w)
converter initUnalignedLVecBase4f*[T0, T1, T2, T3: SomeNumber](args: tuple[x: T0, y: T1, z: T2, w: T3]): UnalignedLVecBase4f {.inline, noSideEffect.} = UnalignedLVecBase4f(x: (float32)args.x, y: (float32)args.y, z: (float32)args.z, w: (float32)args.w)
converter initUnalignedLVecBase4f*(copy: LVecBase4f): UnalignedLVecBase4f = UnalignedLVecBase4f(x: copy.x, y: copy.y, z: copy.z, w: copy.w)

func initUnalignedLVecBase4d*(): UnalignedLVecBase4d = UnalignedLVecBase4d(x: 0, y: 0, z: 0, w: 0)
func initUnalignedLVecBase4d*(copy: UnalignedLVecBase4d): UnalignedLVecBase4d = UnalignedLVecBase4d(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
func initUnalignedLVecBase4d*(fill_value: float64): UnalignedLVecBase4d = UnalignedLVecBase4d(x: fill_value, y: fill_value, z: fill_value, w: fill_value)
func initUnalignedLVecBase4d*(x: float64, y: float64, z: float64, w: float64): UnalignedLVecBase4d = UnalignedLVecBase4d(x: x, y: y, z: z, w: w)
converter initUnalignedLVecBase4d*[T0, T1, T2, T3: SomeNumber](args: tuple[x: T0, y: T1, z: T2, w: T3]): UnalignedLVecBase4d {.inline, noSideEffect.} = UnalignedLVecBase4d(x: (float64)args.x, y: (float64)args.y, z: (float64)args.z, w: (float64)args.w)
converter initUnalignedLVecBase4d*(copy: LVecBase4d): UnalignedLVecBase4d = UnalignedLVecBase4d(x: copy.x, y: copy.y, z: copy.z, w: copy.w)

func initUnalignedLVecBase4i*(): UnalignedLVecBase4i = UnalignedLVecBase4i(x: 0, y: 0, z: 0, w: 0)
func initUnalignedLVecBase4i*(copy: UnalignedLVecBase4i): UnalignedLVecBase4i = UnalignedLVecBase4i(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
func initUnalignedLVecBase4i*(fill_value: int32): UnalignedLVecBase4i = UnalignedLVecBase4i(x: fill_value, y: fill_value, z: fill_value, w: fill_value)
func initUnalignedLVecBase4i*(x: int32, y: int32, z: int32, w: int32): UnalignedLVecBase4i = UnalignedLVecBase4i(x: x, y: y, z: z, w: w)
converter initUnalignedLVecBase4i*[T0, T1, T2, T3: int | int32](args: tuple[x: T0, y: T1, z: T2, w: T3]): UnalignedLVecBase4i {.inline, noSideEffect.} = UnalignedLVecBase4i(x: (int32)args.x, y: (int32)args.y, z: (int32)args.z, w: (int32)args.w)
converter initUnalignedLVecBase4i*(copy: LVecBase4i): UnalignedLVecBase4i = UnalignedLVecBase4i(x: copy.x, y: copy.y, z: copy.z, w: copy.w)
"""

# Generate vector swizzle operators
for base in "LVecBase", "LVector", "LPoint":
    for suffix in 'fdi':
        CORE_POSTAMBLE += "\n"
        for x in 'xy':
            for y in 'xy':
                CORE_POSTAMBLE += f"func {x}{y}*(this: {base}2{suffix}): {base}2{suffix} = {base}2{suffix}(x: this.{x}, y: this.{y})\n"
                if base == "LVecBase" and x != y:
                    CORE_POSTAMBLE += f"func `{x}{y}=`*(this: var {base}2{suffix}, other: LVecBase2{suffix}) =\n  this.{x} = other.x\n  this.{y} = other.y\n"
                for z in 'xy':
                    CORE_POSTAMBLE += f"func {x}{y}{z}*(this: {base}2{suffix}): {base}3{suffix} = {base}3{suffix}(x: this.{x}, y: this.{y}, z: this.{z})\n"
                    if base == "LVecBase" and x != y != z:
                        CORE_POSTAMBLE += f"func `{x}{y}{z}=`*(this: var {base}2{suffix}, other: LVecBase3{suffix}) =\n  this.{x} = other.x\n  this.{y} = other.y\n  this.{z} = other.z\n"
                    for w in 'xy':
                        CORE_POSTAMBLE += f"func {x}{y}{z}{w}*(this: {base}2{suffix}): {base}4{suffix} = {base}4{suffix}(x: this.{x}, y: this.{y}, z: this.{z}, w: this.{w})\n"
                        if base == "LVecBase" and x != y != z != w:
                            CORE_POSTAMBLE += f"func `{x}{y}{z}{w}=`*(this: var {base}2{suffix}, other: LVecBase4{suffix}) =\n  this.{x} = other.x\n  this.{y} = other.y\n  this.{z} = other.z\n  this.{w} = other.w\n"

        CORE_POSTAMBLE += "\n"
        for x in 'xyz':
            for y in 'xyz':
                CORE_POSTAMBLE += f"func {x}{y}*(this: {base}3{suffix}): {base}2{suffix} = {base}2{suffix}(x: this.{x}, y: this.{y})\n"
                if base == "LVecBase" and x != y:
                    CORE_POSTAMBLE += f"func `{x}{y}=`*(this: var {base}3{suffix}, other: LVecBase2{suffix}) =\n  this.{x} = other.x\n  this.{y} = other.y\n"
                for z in 'xyz':
                    CORE_POSTAMBLE += f"func {x}{y}{z}*(this: {base}3{suffix}): {base}3{suffix} = {base}3{suffix}(x: this.{x}, y: this.{y}, z: this.{z})\n"
                    if base == "LVecBase" and x != y != z:
                        CORE_POSTAMBLE += f"func `{x}{y}{z}=`*(this: var {base}3{suffix}, other: LVecBase3{suffix}) =\n  this.{x} = other.x\n  this.{y} = other.y\n  this.{z} = other.z\n"
                    for w in 'xyz':
                        CORE_POSTAMBLE += f"func {x}{y}{z}{w}*(this: {base}3{suffix}): {base}4{suffix} = {base}4{suffix}(x: this.{x}, y: this.{y}, z: this.{z}, w: this.{w})\n"
                        if base == "LVecBase" and x != y != z != w:
                            CORE_POSTAMBLE += f"func `{x}{y}{z}{w}=`*(this: var {base}3{suffix}, other: LVecBase4{suffix}) =\n  this.{x} = other.x\n  this.{y} = other.y\n  this.{z} = other.z\n  this.{w} = other.w\n"

        CORE_POSTAMBLE += "\n"
        for x in 'xyzw':
            for y in 'xyzw':
                CORE_POSTAMBLE += f"func {x}{y}*(this: {base}4{suffix}): {base}2{suffix} = {base}2{suffix}(x: this.{x}, y: this.{y})\n"
                if base == "LVecBase" and x != y:
                    CORE_POSTAMBLE += f"func `{x}{y}=`*(this: var {base}4{suffix}, other: LVecBase2{suffix}) =\n  this.{x} = other.x\n  this.{y} = other.y\n"
                for z in 'xyzw':
                    CORE_POSTAMBLE += f"func {x}{y}{z}*(this: {base}4{suffix}): {base}3{suffix} = {base}3{suffix}(x: this.{x}, y: this.{y}, z: this.{z})\n"
                    if base == "LVecBase" and x != y != z:
                        CORE_POSTAMBLE += f"func `{x}{y}{z}=`*(this: var {base}4{suffix}, other: LVecBase3{suffix}) =\n  this.{x} = other.x\n  this.{y} = other.y\n  this.{z} = other.z\n"
                    for w in 'xyzw':
                        CORE_POSTAMBLE += f"func {x}{y}{z}{w}*(this: {base}4{suffix}): {base}4{suffix} = {base}4{suffix}(x: this.{x}, y: this.{y}, z: this.{z}, w: this.{w})\n"
                        if base == "LVecBase" and x != y != z != w:
                            CORE_POSTAMBLE += f"func `{x}{y}{z}{w}=`*(this: var {base}4{suffix}, other: LVecBase4{suffix}) =\n  this.{x} = other.x\n  this.{y} = other.y\n  this.{z} = other.z\n  this.{w} = other.w\n"

OTHER_PREAMBLE = \
"""
import ./private
import ./core

when defined(vcc):
  when defined(pandaDir):
    {.passL: "\\"" & pandaDir & "/lib/lib%(libname)s.lib\\"".}
  else:
    {.passL: "lib%(libname)s.lib".}
else:
  {.passL: "-l%(libname)s".}

"""

ATOMIC_TYPES = ["object", "int", "float32", "float64", "bool", "char", "void", "string", "clonglong", "type(nil)"]
NIM_KEYWORDS = {"addr", "and", "as", "asm", "bind", "block", "break", "case", "cast", "concept", "const", "continue", "converter", "defer", "discard", "distinct", "div", "do", "elif", "else", "end", "enum", "except", "export", "finally", "for", "from", "func", "if", "import", "in", "include", "interface", "is", "isnot", "iterator", "let", "macro", "method", "mixin", "mod", "nil", "not", "notin", "object", "of", "or", "out", "proc", "ptr", "raise", "ref", "return", "shl", "shr", "static", "template", "try", "tuple", "type", "using", "var", "when", "while", "xor", "yield"}
FORCE_POINTER_TYPES = {"ReferenceCount", "EventQueue", "GraphicsPipeSelection", "TypedObject", "AnimInterface", "TypedWritable", "SavedContext", "ConnectionListener", "SimpleAllocatorBlock", "Namable", "CIntervalManager"}
INPLACE_OPERATORS = {"=", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "<<=", ">>=", "++", "--"}
FUNCTION_IGNORE = {
    "operator %=",
    "operator &=",
    "operator ()",
    "operator ()",
    "operator <<=",
    "operator =",
    "operator >>=",
    "operator ^=",
    "operator new",
    "operator |=",
    "operator ~=",
}
FUNCTION_REMAP = {
    "__cmp__": "cmp",
    "__floordiv__": "div",
    "__len__": "len",
    "__pow__": "pow",
    "operator %": "mod",
    "operator &": "and",
    "operator ++": "inc",
    "operator --": "dec",
    "operator <<": "shl",
    "operator >>": "shr",
    "operator ^": "xor",
    "operator |": "or",
    "operator ~": "not",
    "size": "len",
}
FORCE_VAR_METHODS = {
    "BitArray::*",
    "BitMask< uint16_t, 16 >::*",
    "BitMask< uint32_t, 32 >::*",
    "BitMask< uint64_t, 64 >::*",
    "ButtonHandle::*",
    "DSearchPath::*",
    "FrameBufferProperties::*",
    "GlobPattern::*",
    "LMatrix3d::*",
    "LMatrix3f::*",
    "LMatrix4d::*",
    "LMatrix4f::*",
    "LoaderOptions::*",
    "LPoint2d::*",
    "LPoint2f::*",
    "LPoint2i::*",
    "LPoint3d::*",
    "LPoint3f::*",
    "LPoint3i::*",
    "LPoint4d::*",
    "LPoint4f::*",
    "LPoint4i::*",
    "LVecBase2d::*",
    "LVecBase2f::*",
    "LVecBase2i::*",
    "LVecBase3d::*",
    "LVecBase3f::*",
    "LVecBase3i::*",
    "LVecBase4d::*",
    "LVecBase4f::*",
    "LVecBase4i::*",
    "LVector2d::*",
    "LVector2f::*",
    "LVector2i::*",
    "LVector3d::*",
    "LVector3f::*",
    "LVector3i::*",
    "LVector4d::*",
    "LVector4f::*",
    "LVector4i::*",
    "NetAddress::*",
    "NodePath::clear",
    "SamplerState::*",
    "SparseArray::*",
    "UnalignedLVecBase4d::*",
    "UnalignedLVecBase4f::*",
    "UnalignedLVecBase4i::*",
    "URLSpec::*",
    "WeakNodePath::clear",
    "WindowProperties::*",
}

# Normally the header names are inferred from the type, but this doesn't
# always work, so we have this table for overrides.
TYPE_HEADERS = {
    "AdaptiveLruPage": "adaptiveLru.h",
    "ARToolKit": "arToolKit.h",
    "BitMask16": "bitMask.h",
    "BitMask32": "bitMask.h",
    "BitMask64": "bitMask.h",
    "BitMaskNative": "bitMask.h",
    "Buffered_DatagramConnection": "buffered_datagramconnection.h",
    "BulletContact": "bulletContactResult.h",
    "BulletRayHit": "bulletAllHitsRayResult.h",
    "BulletSoftBodyNodeElement": "bulletSoftBodyNode.h",
    "BulletUpAxis": "bullet_utils.h",
    "BulletVehicleTuning": "bulletVehicle.h",
    "BulletWheelRaycastInfo": "bulletWheel.h",
    "ColorInterpolationSegment": "colorInterpolationManager.h",
    "ConstPointerToArray": "pointerToArray.h",
    "DCPacker": "dcPacker.h",
    "DCPackType": "dcPackerInterface.h",
    "DisplayMode": "displayInformation.h",
    "dxBody": "<ode/ode.h>",
    "dxGeom": "<ode/ode.h>",
    "dxJoint": "<ode/ode.h>",
    "dxJointGroup": "<ode/ode.h>",
    "dxSpace": "<ode/ode.h>",
    "dxTriMeshData": "<ode/ode.h>",
    "dxWorld": "<ode/ode.h>",
    "EaseInBlendType": "lerpblend.h",
    "EaseInOutBlendType": "lerpblend.h",
    "EaseOutBlendType": "lerpblend.h",
    "EggSwitchConditionDistance": "eggSwitchCondition.h",
    "ErrorUtilCode": "error_utils.h",
    "FadeLODNode": "fadeLodNode.h",
    "FileStream": "pandaFileStream.h",
    "fstream": "<fstream>",
    "GeomVertexArrayDataHandle": "geomVertexArrayData.h",
    "IDecompressStream": "zStream.h",
    "IDecryptStream": "encryptStream.h",
    "IESDataset": "iesDataset.h",
    "IFileStream": "pandaFileStream.h",
    "ifstream": "<fstream>",
    "ios_base": "<ios>",
    "iostream": "<iostream>",
    "ISocketStream": "socketStream.h",
    "istream": "<istream>",
    "IStreamWrapper": "streamWrapper.h",
    "ISubStream": "subStream.h",
    "LerpBlendType": "lerpblend.h",
    "LFrustum": "frustum.h",
    "LFrustumd": "frustum.h",
    "LFrustumf": "frustum.h",
    "LMatrix3d": "lmatrix.h",
    "LMatrix3f": "lmatrix.h",
    "LMatrix4d": "lmatrix.h",
    "LMatrix4f": "lmatrix.h",
    "LODNode": "lodNode.h",
    "LODNodeType": "lodNodeType.h",
    "LParabola": "parabola.h",
    "LParabolad": "parabola.h",
    "LParabolaf": "parabola.h",
    "LPlane": "plane.h",
    "LPlaned": "plane.h",
    "LPlanef": "plane.h",
    "Mutex": "pmutex.h",
    "NoBlendType": "lerpblend.h",
    "Notify": "pnotify.h",
    "OCompressStream": "zStream.h",
    "OdeJointFeedback": "odeJoint.h",
    "OEncryptStream": "encryptStream.h",
    "OFileStream": "pandaFileStream.h",
    "ofstream": "<fstream>",
    "OSocketStream": "socketStream.h",
    "ostream": "<ostream>",
    "OStreamWrapper": "streamWrapper.h",
    "OSubStream": "subStream.h",
    "ParamTextureImage": "paramTexture.h",
    "ParamTextureSampler": "paramTexture.h",
    "ParamTypedRefCount": "paramValue.h",
    "ParamValueBase": "paramValue.h",
    "pfstream": "pandaFileStream.h",
    "pifstream": "pandaFileStream.h",
    "pixel": "pnmimage_base.h",
    "pofstream": "pandaFileStream.h",
    "PointerType": "pointerData.h",
    "PSSMCameraRig": "pssmCameraRig.h",
    "RPLight": "rpLight.h",
    "RPPointLight": "rpPointLight.h",
    "RPSpotLight": "rpSpotLight.h",
    "Semaphore": "psemaphore.h",
    "SimpleAllocatorBlock": "simpleAllocator.h",
    "SimpleLruPage": "simpleLru.h",
    "Socket_Address": "socket_address.h",
    "Socket_IP": "socket_ip.h",
    "Socket_TCP": "socket_tcp.h",
    "Socket_TCP_Listen": "socket_tcp_listen.h",
    "Socket_UDP": "socket_udp.h",
    "Socket_UDP_Incoming": "socket_udp_incoming.h",
    "Socket_UDP_Outgoing": "socket_udp_outgoing.h",
    "SpriteAnim": "spriteParticleRenderer.h",
    "SpriteWriter": "spriteParticleRenderer.h",
    "SSReader": "socketStream.h",
    "SSWriter": "socketStream.h",
    "StreamWrapperBase": "streamWrapper.h",
    "TimeVal": "clockObject.h",
    "TiXmlAttribute": "tinyxml.h",
    "TiXmlAttributeSet": "tinyxml.h",
    "TiXmlBase": "tinyxml.h",
    "TiXmlComment": "tinyxml.h",
    "TiXmlCursor": "tinyxml.h",
    "TiXmlDeclaration": "tinyxml.h",
    "TiXmlDocument": "tinyxml.h",
    "TiXmlElement": "tinyxml.h",
    "TiXmlEncoding": "tinyxml.h",
    "TiXmlHandle": "tinyxml.h",
    "TiXmlNode": "tinyxml.h",
    "TiXmlPrinter": "tinyxml.h",
    "TiXmlText": "tinyxml.h",
    "TiXmlUnknown": "tinyxml.h",
    "TiXmlVisitor": "tinyxml.h",
    "Transform2SG": "transform2sg.h",
    "UnalignedLMatrix4d": "lmatrix.h",
    "UnalignedLMatrix4f": "lmatrix.h",
    "UnalignedLVecBase4d": "lvecBase4.h",
    "UnalignedLVecBase4f": "lvecBase4.h",
    "UnalignedLVecBase4i": "lvecBase4.h",
    "URLSpec": "urlSpec.h",
}

FUNC_HEADERS = {
    "auto_bind": "auto_bind.h",
    "compose_matrix": "compose_matrix.h",
    "decompose_matrix": "decompose_matrix.h",
    "load_prc_file": "load_prc_file.h",
    "load_prc_file_data": "load_prc_file.h",
}


def translate_comment(code, prefix="## "):
    if not code:
        return ""

    if 'gluPerspective' in code:
        return ""

    comment = ''

    empty_line = False
    for line in code.lstrip('/ <\n').rstrip('*/ \n\t').splitlines(False):
        line = line.strip('\t\n ').lstrip('*/ ')
        if line:
            if empty_line:
                # New paragraph.
                if comment:
                    comment += '\n' + prefix.rstrip() + '\n'
                empty_line = False
            elif comment:
                comment += '\n'
            comment += prefix + line
        else:
            empty_line = True

    comment = comment.rstrip()
    if comment:
        return comment.replace('*', '\\*').replace('|', '\\|')
    else:
        return ''


def translate_function_name(name):
    if name in FUNCTION_REMAP:
        new = FUNCTION_REMAP[name]
    elif name.startswith("operator "):
        new = '`' + name[9:] + '`'
    elif name.startswith("__"):
        new = name
    else:
        new = ""
        for i in name.split("_"):
            if new == "":
                new += i
            elif i == "":
                pass
            elif len(i) == 1:
                new += i[0].upper()
            else:
                new += i[0].upper() + i[1:]

    if new in NIM_KEYWORDS:
        new = '`' + new + '`'
    return new


def translate_type_name(name, mangle=False):
    if name == "int":
        return ATOMIC_TYPES[1]
    elif name == "float":
        return ATOMIC_TYPES[2]
    elif name == "double":
        return ATOMIC_TYPES[3]
    elif name == "time_t":
        return "Time"
    elif (name.startswith("int") or name.startswith("uint")) and name.endswith("_t"):
        return name.rstrip("_t")

    # Equivalent to C++ classNameFromCppName
    class_name = ""
    bad_chars = "!@#$%^&*()<>,.-=+~{}? "
    next_cap = False
    first_char = mangle

    for chr in name:
        if (chr == '_' or chr == ' ') and mangle:
            next_cap = True
        elif chr in bad_chars:
            if not mangle:
                class_name += '_'
        elif next_cap or first_char:
            class_name += chr.upper()
            next_cap = False
            first_char = False
        else:
            class_name += chr

    return class_name


def translated_type_name(type, scoped=True, template=True):
    while interrogate_type_is_wrapped(type) or (interrogate_type_is_typedef(type) and not interrogate_type_is_global(type)):
        type_name = interrogate_type_name(type)
        if type_name == "time_t":
            return "Time"
        elif type_name == "PN_stdfloat":
            # For now, map to float64
            return "float"
        elif type_name == "size_t":
            return "int"

        type = interrogate_type_wrapped_type(type)

    type_name = interrogate_type_name(type)
    if type_name in ("PyObject", "_object"):
        return "object"

    if interrogate_type_is_atomic(type):
        token = interrogate_type_atomic_token(type)
        return ATOMIC_TYPES[token]

    if '<' in type_name:
        type_name, tmpl_args = type_name.split('<', 1)
        tmpl_args = tmpl_args.strip('<> ').split(', ')
        tmpl_args = ', '.join([name if name[0].isnumeric() else translate_type_name(name) for name in tmpl_args])
    else:
        tmpl_args = None

    type_name = translate_type_name(type_name)

    if tmpl_args and template:
        type_name += '[' + tmpl_args + ']'

    if scoped and interrogate_type_is_nested(type):
        return translated_type_name(interrogate_type_outer_class(type)) + '_' + type_name
    else:
        return type_name


def bind_coerce_constructor(out, function, wrapper, num_default_args=0):
    return
    cpp_expr = interrogate_function_name(function)
    return_type = interrogate_wrapper_return_type(wrapper)

    cpp_expr += "("

    headers = set()
    args = []
    for i_param in range(interrogate_wrapper_number_of_parameters(wrapper) - num_default_args):
        param_name = interrogate_wrapper_parameter_name(wrapper, i_param)
        if param_name.startswith("_"):
            return
        if param_name in NIM_KEYWORDS:
            param_name = '`' + param_name + '`'

        param_type = interrogate_wrapper_parameter_type(wrapper, i_param)
        if not is_type_valid(param_type):
            return
        type_name = translated_type_name(param_type)

        args.append(f"{param_name}: {type_name}")

        if not cpp_expr.endswith("("):
            cpp_expr += ", "

        if type_name == "string":
            cpp_expr += f"nimStringToStdString(@.Field{i_param})"
            headers.add("stringConversionCode")
        else:
            cpp_expr += f"@.Field{i_param}"

    cpp_expr += ")"

    type_name = translated_type_name(return_type, scoped=False, template=False)
    args_string = ", ".join(args)
    out.write(f"converter init{type_name}*(args: tuple[{args_string}])")

    if type_name.startswith("BitMask["):
        type_name = "BitMask" + type_name.rstrip(']').split(", ")[-1]

    out.write(f": {type_name}")

    if len(headers) == 0:
        out.write(f" {{.importcpp: \"{cpp_expr}\".}}")
    else:
        header = sorted(headers)[0]
        out.write(f" {{.importcpp: \"{cpp_expr}\", header: {header}.}}")

    if interrogate_wrapper_has_comment(wrapper):
        comment = translate_comment(interrogate_wrapper_comment(wrapper))
        if comment:
            out.write(" ## \\\n" + comment)

    out.write("\n\n")


def bind_function_overload(out, function, wrapper, func_name, proc_type="proc", num_default_args=0):
    this_pointer = False
    this_var = False

    cpp_expr = interrogate_function_name(function)

    if cpp_expr in ("operator ++", "operator --") and interrogate_wrapper_number_of_parameters(wrapper) >= 2:
        return

    if interrogate_wrapper_has_return_value(wrapper) and (not func_name.startswith("operator ") or func_name[9:] not in INPLACE_OPERATORS):
        return_type = interrogate_wrapper_return_type(wrapper)
        if not is_type_valid(return_type):
            return False
    else:
        return_type = None

    headers = set()
    args = []
    if interrogate_function_is_method(function):
        this_type = interrogate_function_class(function)
        if not is_type_valid(this_type):
            if func_name != "get_class_type":
                scoped_type_name = interrogate_type_scoped_name(this_type)
                if scoped_type_name == "MovingPart< ACMatrixSwitchType >":
                    this_type = interrogate_get_type_by_scoped_name("MovingPartMatrix")
                elif scoped_type_name == "MovingPart< ACScalarSwitchType >":
                    this_type = interrogate_get_type_by_scoped_name("MovingPartScalar")
                else:
                    return False
            else:
                return False

        if is_type_pointer(this_type):
            this_pointer = True
        elif interrogate_function_scoped_name(function) in FORCE_VAR_METHODS:
            this_var = True
        elif (interrogate_type_scoped_name(this_type) + "::*") in FORCE_VAR_METHODS:
            this_var = True

        if interrogate_function_is_constructor(function):
            type_name = translated_type_name(this_type)
            if type_name.startswith("BitMask["):
                type_name = "BitMask" + type_name.rstrip(']').split(", ")[-1]

            if this_pointer:
                func_name = "new" + type_name
                cpp_expr = f"new {type_name}"
            else:
                func_name = "init" + type_name
                cpp_expr = type_name

                if interrogate_wrapper_is_coerce_constructor(wrapper):
                    num_args = interrogate_wrapper_number_of_parameters(wrapper) - num_default_args
                    if num_args == 1 and \
                       interrogate_wrapper_is_coerce_constructor(wrapper) and \
                       is_type_valid(interrogate_wrapper_parameter_type(wrapper, 0)):
                        # These constructors not being marked explicit is a mistake
                        # in Panda3D 1.10 that will be rectified in 1.11.
                        if not type_name.startswith("ConfigVariable") and \
                           type_name != "LoaderOptions" and \
                           type_name != "pixel" and \
                           (type_name != "ButtonHandle" or interrogate_wrapper_parameter_name(wrapper, 0) != "index") and \
                           interrogate_wrapper_parameter_name(wrapper, 0) != "fill_value":
                            proc_type = "converter"
                    elif num_args > 1 and is_type_valid(interrogate_wrapper_parameter_type(wrapper, 0)):
                        # Accept a tuple for coercion.
                        if not type_name.startswith("ConfigVariable") and \
                           (not type_name.startswith("LVecBase2") or interrogate_wrapper_number_of_parameters(wrapper) == 2) and \
                           (not type_name.startswith("LVecBase3") or interrogate_wrapper_number_of_parameters(wrapper) == 3) and \
                           (not type_name.startswith("LVecBase4") or interrogate_wrapper_number_of_parameters(wrapper) == 4) and \
                           (not type_name.startswith("UnalignedLVecBase4") or interrogate_wrapper_number_of_parameters(wrapper) == 4):
                            bind_coerce_constructor(out, function, wrapper, num_default_args=num_default_args)

        elif (interrogate_wrapper_number_of_parameters(wrapper) == 0 or \
            not interrogate_wrapper_parameter_is_this(wrapper, 0)) and \
           not interrogate_function_is_constructor(function):
            # It's static, add a typedesc parameter.
            type_name = translated_type_name(this_type)
            if func_name == "size" and interrogate_wrapper_number_of_parameters(wrapper) == 0:
                args.append(f"_: typedesc[{type_name}] or {type_name}")
            else:
                args.append(f"_: typedesc[{type_name}]")
            cpp_expr = f"{interrogate_type_name(this_type)}::{cpp_expr}"

            # Insert a dummy # (gets expanded to nothing) to cover this param
            if interrogate_wrapper_number_of_parameters(wrapper) - num_default_args > 0:
                cpp_expr = "#" + cpp_expr

            header = get_type_header(this_type)
            if header:
                header_path = "C:\\Users\\rdb\\panda3d2\\built_x64\\include\\" + header
                if not os.path.isfile(header_path):
                    print("Header not found: ", header)
                else:
                    resolved = pathlib.Path(header_path).resolve()
                    recased = str(resolved).replace('\\', '/').split('/')[-1]
                    if recased != header:
                        print("Header wrong case: ", header, recased)
                headers.add('"' + header + '"')

        elif this_pointer:
            cpp_expr = f"#->{cpp_expr}"

        else:
            cpp_expr = f"#.{cpp_expr}"
    else:
        header = get_func_header(function)
        if header:
            headers.add('"' + header + '"')


    cpp_args = []
    for i_param in range(interrogate_wrapper_number_of_parameters(wrapper) - num_default_args):
        param_name = interrogate_wrapper_parameter_name(wrapper, i_param)
        if param_name.startswith("_"):
            return False
        if param_name in NIM_KEYWORDS:
            param_name = '`' + param_name + '`'

        param_type = interrogate_wrapper_parameter_type(wrapper, i_param)
        if not is_type_valid(param_type):
            if interrogate_wrapper_parameter_is_this(wrapper, i_param):
                param_type = this_type
            else:
                return False
        type_name = translated_type_name(param_type)

        if interrogate_wrapper_parameter_is_this(wrapper, i_param):
            if interrogate_type_true_name(param_type).endswith("const *") and \
               interrogate_function_number_of_python_wrappers(function) > 1 and \
               func_name != "operator []":
                # Is there a non-const version?  Then we skip this.
                for i_wrapper in range(interrogate_function_number_of_python_wrappers(function)):
                    wrapper2 = interrogate_function_python_wrapper(function, i_wrapper)
                    if interrogate_wrapper_number_of_parameters(wrapper2) > 0 and \
                       interrogate_wrapper_parameter_is_this(wrapper2, 0) and \
                       not interrogate_type_true_name(interrogate_wrapper_parameter_type(wrapper2, 0)).endswith("const *"):
                        return False

            if type_name.startswith("LVecBase") or type_name.startswith("UnalignedLVecBase") or type_name.startswith("LVector") or type_name.startswith("LPoint"):
                # Awful hack
                if interrogate_type_true_name(param_type).endswith("const *"):
                    cpp_expr = "((" + type_name + " const &)#)" + cpp_expr[1:]
                else:
                    cpp_expr = "((" + type_name + " &)#)" + cpp_expr[1:]

            if func_name.startswith("operator ") and func_name[9:] in INPLACE_OPERATORS:
                args.append(f"{param_name}: var {type_name}")
            elif not this_var or interrogate_type_true_name(param_type).endswith("const *"):
                #if not this_pointer and not interrogate_type_true_name(param_type).endswith("const *"):
                #    print(interrogate_function_scoped_name(function))
                args.append(f"{param_name}: {type_name}")
            else:
                args.append(f"{param_name}: var {type_name}")
        else:
            args.append(f"{param_name}: {type_name}")

            if type_name == "string":
                cpp_args.append("nimStringToStdString(#)")
                headers.add("stringConversionCode")
            elif type_name.startswith("LVecBase") or type_name.startswith("UnalignedLVecBase") or type_name.startswith("LVector") or type_name.startswith("LPoint"):
                # Awful hack
                if interrogate_type_true_name(param_type).endswith("const *"):
                    cpp_args.append("(" + type_name + " const &)(#)")
                else:
                    cpp_args.append("(" + type_name + " &)(#)")
            else:
                cpp_args.append("#")

    if func_name == "operator []" and interrogate_wrapper_number_of_parameters(wrapper) > 2:
        func_name = "`[]=`"
        cpp_suffix = cpp_args.pop()
        cpp_expr += "(" + ", ".join(cpp_args) + ")"
        cpp_expr += " = " + cpp_suffix
    else:
        func_name = translate_function_name(func_name)
        cpp_expr += "(" + ", ".join(cpp_args) + ")"

    args_string = ", ".join(args)

    out.write(f"{proc_type} {func_name}*({args_string})")

    if return_type:
        type_name = translated_type_name(return_type)
        if type_name.startswith("BitMask["):
            type_name = "BitMask" + type_name.rstrip(']').split(", ")[-1]

        if func_name.startswith("upcastTo") and not this_pointer:
            out.write(f": var {type_name}")
        else:
            out.write(f": {type_name}")

        if func_name.startswith("upcastTo"):
            while interrogate_type_is_wrapped(return_type):
                return_type = interrogate_type_wrapped_type(return_type)

            cpp_name = interrogate_type_scoped_name(return_type)
            if not this_pointer:
                cpp_expr = f"(({cpp_name} *)&(#))"
            elif is_type_reference_counted(return_type):
                cpp_expr = f"(PT({cpp_name})(#))"
            elif is_type_reference_counted(this_type):
                cpp_expr = f"(({cpp_name} *)({interrogate_type_true_name(this_type)} *)(#))"
            else:
                cpp_expr = f"(({cpp_name} *)(#))"

        elif func_name.startswith("`typecast "):
            if this_pointer:
                cpp_expr = f"({func_name[10:-1]})*(#)"
            else:
                cpp_expr = f"({func_name[10:-1]})(#)"

        elif this_pointer and interrogate_type_is_pointer(return_type) and interrogate_type_is_const(interrogate_type_wrapped_type(return_type)):
            if is_type_reference_counted(return_type):
                cpp_expr = f"deconstify({cpp_expr})"
                headers.add("deconstifyCode")

        elif type_name == "string":
            cpp_expr = "nimStringFromStdString(" + cpp_expr + ")"
            headers.add("stringConversionCode")

    if len(headers) == 0:
        out.write(f" {{.importcpp: \"{cpp_expr}\".}}")
    else:
        header = sorted(headers)[0]
        out.write(f" {{.importcpp: \"{cpp_expr}\", header: {header}.}}")

    if interrogate_wrapper_has_comment(wrapper):
        comment = translate_comment(interrogate_wrapper_comment(wrapper))
        if comment:
            out.write(" ## \\\n" + comment)

    out.write("\n\n")
    return True


def bind_function(out, function, func_name=None, proc_type="proc"):
    if not func_name:
        func_name = interrogate_function_name(function)

        if func_name in FUNCTION_IGNORE:
            return

        if func_name.startswith("_") and func_name not in FUNCTION_REMAP:
            return

        if func_name == "get_class_type" or func_name.startswith("upcast_to_") or func_name.startswith("operator typecast "):
            proc_type = "converter"

        if func_name == "size":
            proc_type = "func"

    if func_name in NIM_KEYWORDS:
        return

    if (not func_name.strip('xyzw')) or interrogate_function_is_constructor(function):
        type_name = interrogate_type_name(interrogate_function_class(function))
        if type_name.startswith("LVecBase") or type_name.startswith("UnalignedLVecBase"):
            return

    overloads = {}
    for i_wrapper in range(interrogate_function_number_of_python_wrappers(function)):
        wrapper = interrogate_function_python_wrapper(function, i_wrapper)

        num_optional_args = 0
        for i_param in range(interrogate_wrapper_number_of_parameters(wrapper)):
            if interrogate_wrapper_parameter_is_optional(wrapper, i_param):
                num_optional_args += 1

        for num_default_args in range(num_optional_args + 1):
            sig = tuple(interrogate_wrapper_parameter_type(wrapper, i) for i in range(interrogate_wrapper_number_of_parameters(wrapper) - num_default_args))
            if sig not in overloads:
                if bind_function_overload(out, function, wrapper, func_name, proc_type, num_default_args):
                    overloads[sig] = wrapper


def bind_property(out, element):
    if interrogate_element_is_mapping(element) or \
       interrogate_element_is_sequence(element):
        return

    #type_name = translated_type_name(interrogate_element_type(element))
    prop_name = interrogate_element_name(element)

    if not prop_name.strip('xyzw'):
        scoped_name = interrogate_element_scoped_name(element)
        if scoped_name.startswith("LVecBase") or scoped_name.startswith("UnalignedLVecBase") or scoped_name.startswith("LVector") or scoped_name.startswith("LPoint"):
            return

    #out.write(f"proc {prop_name}*(this: {parent_type_name}): {type_name}")

    #if this_pointer:
    #    out.write(f" {{.importcpp: \"#->{prop_name}()\".}}\n\n")
    #else:
    #    out.write(f" {{.importcpp: \"#.{prop_name}\".}}\n\n")

    if interrogate_element_has_getter(element):
        bind_function(out, interrogate_element_getter(element), prop_name, "func")

    if interrogate_element_has_setter(element):
        bind_function(out, interrogate_element_setter(element), f"`{prop_name}=`")


def is_type_pointer(type):
    while interrogate_type_is_wrapped(type) or interrogate_type_is_typedef(type):
        type = interrogate_type_wrapped_type(type)

    dtor = interrogate_type_get_destructor(type)
    if dtor and interrogate_function_is_virtual(dtor):
        return True

    for i in range(interrogate_type_number_of_derivations(type)):
        base_type = interrogate_type_get_derivation(type, i)
        if is_type_reference_counted(base_type):
            return True

    if interrogate_type_name(type) in FORCE_POINTER_TYPES:
        return True

    return False


def is_type_reference_counted(type):
    while interrogate_type_is_wrapped(type) or interrogate_type_is_typedef(type):
        type = interrogate_type_wrapped_type(type)

    if interrogate_type_name(type) == "ReferenceCount":
        return True

    for i in range(interrogate_type_number_of_derivations(type)):
        base_type = interrogate_type_get_derivation(type, i)
        if is_type_reference_counted(base_type):
            return True

    return False


def is_type_typed(type):
    while interrogate_type_is_wrapped(type) or interrogate_type_is_typedef(type):
        type = interrogate_type_wrapped_type(type)

    if interrogate_type_name(type) == "TypedObject":
        return True

    for i in range(interrogate_type_number_of_derivations(type)):
        base_type = interrogate_type_get_derivation(type, i)
        if is_type_reference_counted(base_type):
            return True

    return False


def is_type_valid(type):
    while interrogate_type_is_wrapped(type) or interrogate_type_is_typedef(type):
        type = interrogate_type_wrapped_type(type)

    if interrogate_type_is_atomic(type):
        return True

    if interrogate_type_is_nested(type):
        if interrogate_type_is_enum(type) and not interrogate_type_is_scoped_enum(type) and interrogate_type_number_of_enum_values(type) > 0:
            return True
        return False

    if not interrogate_type_is_global(type):
        return False

    type_name = interrogate_type_name(type)
    if type_name in ("PyTypeObject", "PyObject", "_object", "_typeobject", "ParamNodePath"):
        return False

    if type_name.count("<") > 1:
        return False

    if "<" in type_name:
        return type_name.startswith("BitMask")

    return True


def get_type_header(type):
    while interrogate_type_is_nested(type):
        type = interrogate_type_outer_class(type)

    if interrogate_type_is_atomic(type):
        return None

    type_name = interrogate_type_name(type)
    type_name = type_name.split('<')[0]
    if type_name in TYPE_HEADERS:
        return TYPE_HEADERS[type_name]

    if type_name.startswith("L") and type_name[-1] in ("f", "d", "i"):
        # LPoint3f et al
        type_name = "l" + type_name[1].lower() + type_name[2:-1]

    if type_name.startswith("ColorInterpolationFunction"):
        return "colorInterpolationManager.h"

    if type_name.startswith("HTTP"):
        return "http" + type_name[4:] + ".h"

    if type_name.startswith("GPU"):
        return "gpu" + type_name[3:] + ".h"

    if type_name.startswith("PG"):
        return "pg" + type_name[2:] + ".h"

    if type_name.startswith("PNM"):
        return "pnm" + type_name[3:] + ".h"

    if type_name.startswith("AI"):
        return "ai" + type_name[2:] + ".h"

    if type_name.startswith("DC"):
        return "dc" + type_name[2:] + ".h"

    return type_name[0].lower() + type_name[1:] + ".h"


def get_func_header(func):
    if interrogate_function_is_method(func):
        return get_type_header(interrogate_function_class(func))

    func_name = interrogate_function_scoped_name(func)
    if func_name in FUNC_HEADERS:
        return FUNC_HEADERS[func_name]

    return None


def get_type_element_type(type):
    while interrogate_type_is_wrapped(type) or interrogate_type_is_typedef(type):
        type = interrogate_type_wrapped_type(type)

    got_size = False
    element_type = None

    for i_meth in range(interrogate_type_number_of_methods(type)):
        meth = interrogate_type_get_method(type, i_meth)
        meth_name = interrogate_function_name(meth)
        if meth_name == "size":
            got_size = True
        elif meth_name == "operator []":
            for i_wrap in range(interrogate_function_number_of_python_wrappers(meth)):
                wrap = interrogate_function_python_wrapper(meth, i_wrap)
                element_type = interrogate_wrapper_return_type(wrap)
                if interrogate_type_atomic_token(element_type) != 6 and is_type_valid(element_type):
                    break
                else:
                    element_type = None

    if got_size:
        return element_type


def get_type_output_method(type):
    while interrogate_type_is_wrapped(type) or interrogate_type_is_typedef(type):
        type = interrogate_type_wrapped_type(type)

    for i_meth in range(interrogate_type_number_of_methods(type)):
        meth = interrogate_type_get_method(type, i_meth)
        meth_name = interrogate_function_name(meth)
        if meth_name == "output":
            return meth


def bind_type(out, type, bound_templates={}):
    if not is_type_valid(type):
        return

    cpp_name = interrogate_type_name(type)
    type_name = translated_type_name(type, scoped=True, template=False)

    if '<' in cpp_name:
        type_args = []
        cpp_name, tmpl_args = cpp_name.split('<', 1)
        tmpl_args = tmpl_args.strip('<> ').split(', ')

        if cpp_name in bound_templates:
            return
        bound_templates.add(cpp_name)

        cpp_name += '<'
        for i, arg in enumerate(tmpl_args):
            letter = chr(ord('T') + i)
            if arg.isnumeric():
                type_args.append(f"{letter}: static[int]")
            else:
                type_args.append(f"{letter}: static[typedesc]")

            if not cpp_name.endswith('<'):
                cpp_name += ', '
            cpp_name += f"'{i}"

        cpp_name += '>'
    else:
        type_args = None

    type_name_star = type_name
    if not interrogate_type_is_nested(type):
        type_name_star += "*"

    if interrogate_type_is_enum(type):
        if cpp_name:
            # Named enum
            pragmas = [f"importcpp: \"{interrogate_type_scoped_name(type)}\""]

            if interrogate_type_is_scoped_enum(type) or interrogate_type_is_nested(type):
                pragmas.append("pure")

            header = get_type_header(type)
            if header:
                if not os.path.isfile("C:\\Users\\rdb\\panda3d2\\built_x64\\include\\" + header):
                    print("Header not found: ", header)
                pragmas.append(f"header: \"{header}\"")

            pragma_str = ", ".join(pragmas)
            out.write(f"type {type_name_star} {{.{pragma_str}.}} = enum\n")

            if interrogate_type_has_comment(type):
                comment = translate_comment(interrogate_type_comment(type), '  ## ')
                if comment:
                    out.write(comment + "\n")

            values = {}

            for i_value in range(interrogate_type_number_of_enum_values(type)):
                value_name = interrogate_type_enum_value_name(type, i_value)
                value = interrogate_type_enum_value(type, i_value)
                values[value] = value_name

            for value in sorted(values.keys()):
                value_name = values[value]
                if value_name in NIM_KEYWORDS:
                    value_name = '`' + value_name + '`'
                out.write(f"  {value_name} = {value}\n")

            out.write("\n")

        elif not interrogate_type_is_nested(type):
            # Anonymous enum, global scope
            for i_value in range(interrogate_type_number_of_enum_values(type)):
                value_name = interrogate_type_enum_value_name(type, i_value)
                if value_name in NIM_KEYWORDS:
                    value_name = '`' + value_name + '`'
                value = interrogate_type_enum_value(type, i_value)
                out.write(f"const {value_name}*: int = {value}\n")

            out.write("\n")

        if interrogate_type_is_nested(type):
            # Nested enum
            parent_type_name = translated_type_name(interrogate_type_outer_class(type))
            for i_value in range(interrogate_type_number_of_enum_values(type)):
                value_name = interrogate_type_enum_value_name(type, i_value)
                if value_name in NIM_KEYWORDS:
                    value_name = '`' + value_name + '`'
                value = interrogate_type_enum_value(type, i_value)
                out.write(f"template {value_name}*(_: typedesc[{parent_type_name}]): {type_name} = {type_name}.{value_name}\n")

            out.write("\n")

    elif interrogate_type_is_typedef(type):
        wrapped_type = interrogate_type_wrapped_type(type)
        if is_type_valid(wrapped_type) and interrogate_type_is_global(wrapped_type):
            wrapped_type_name = translated_type_name(wrapped_type)
            out.write(f"type {type_name_star} = {wrapped_type_name}\n\n")

            if interrogate_type_has_comment(type):
                comment = translate_comment(interrogate_type_comment(type), '  ## ')
                if comment:
                    out.write("\n" + comment)

    else:
        pragmas = []

        if type_name.startswith("LVecBase") or type_name.startswith("UnalignedLVecBase") or type_name.startswith("LPoint") or type_name.startswith("LVector"):
            size = int(type_name[-2])
            pragmas += [f"importcpp: \"Wrapped{type_name}\", header: wrappedVec{size}Code"]
        elif is_type_reference_counted(type):
            pragmas += [f"importcpp: \"PT({cpp_name})\"", "bycopy"]
        elif is_type_pointer(type):
            pragmas += [f"importcpp: \"{cpp_name}*\"", "bycopy"]
        else:
            pragmas += [f"importcpp: \"{cpp_name}\""]

        pragmas += ["pure"]

        if not interrogate_type_is_final(type):
            pragmas.append("inheritable")

        header = get_type_header(type)
        if header and not type_name.startswith("LVecBase") and not type_name.startswith("UnalignedLVecBase") and not type_name.startswith("LPoint") and not type_name.startswith("LVector"):
            if not os.path.isfile("C:\\Users\\rdb\\panda3d2\\built_x64\\include\\" + header):
                print("Header not found: ", header)
            pragmas.append(f"header: \"{header}\"")

        pragma_str = ", ".join(pragmas)

        if type_args is not None:
            out.write(f"type {type_name_star}[{', '.join(type_args)}] {{.{pragma_str}.}} = object")
        else:
            out.write(f"type {type_name_star} {{.{pragma_str}.}} = object")

        # Determine the class to inherit from.
        valid_bases = []
        for i in range(interrogate_type_number_of_derivations(type)):
            base_type = interrogate_type_get_derivation(type, i)
            if is_type_valid(base_type):
                valid_bases.append(base_type)

        # We inherit from the first base that is typed, if any.
        if valid_bases:
            for base_type in valid_bases:
                if is_type_typed(base_type):
                    break
            else:
                # Grab the first type.
                base_type = valid_bases[0]

            base_name = translated_type_name(base_type)
            if is_type_pointer(type) and not is_type_pointer(base_type):
                print(f"Pointer type {type_name} has non-pointer base {base_name}!")

            out.write(f" of {base_name}")

        if interrogate_type_has_comment(type):
            comment = translate_comment(interrogate_type_comment(type), '  ## ')
            if comment:
                out.write("\n" + comment)

        if type_name.startswith("LVecBase") or type_name.startswith("UnalignedLVecBase"):
            if type_name[-1] == 'f':
                float_type = "float32"
            elif type_name[-1] == 'd':
                float_type = "float64"
            elif type_name[-1] == 'i':
                float_type = "int32"
            else:
                assert False

            num_components = int(type_name[-2])
            if num_components >= 1:
                out.write("\n  x*: " + float_type)
            if num_components >= 2:
                out.write("\n  y*: " + float_type)
            if num_components >= 3:
                out.write("\n  z*: " + float_type)
            if num_components >= 4:
                out.write("\n  w*: " + float_type)

        elif type_name == "pixel":
            out.write("\n  r*: uint16")
            out.write("\n  g*: uint16")
            out.write("\n  b*: uint16")

        out.write("\n\n")

        if is_type_pointer(type):
            out.write(f"converter to{type_name}*(_: type(nil)): {type_name} {{.importcpp: \"(nullptr)\".}}\n")
            out.write(f"converter toBool*(this: {type_name}): bool {{.importcpp: \"(# != nullptr)\".}}\n")
            out.write(f"func `==`*(x: {type_name}, y: type(nil)): bool {{.importcpp: \"(# == nullptr)\".}}\n")

            if cpp_name == "TypedObject":
                out.write(f"func dcast*(_: typedesc[{type_name}], obj: TypedObject): {type_name} {{.importcpp: \"(@)\".}}\n")
            elif is_type_typed(type):
                out.write(f"func dcast*(_: typedesc[{type_name}], obj: TypedObject): {type_name} {{.importcpp: \"DCAST({cpp_name}, @)\".}}\n")

            out.write("\n")

    # Wrap nested enums.
    for i_nested in range(interrogate_type_number_of_nested_types(type)):
        nested = interrogate_type_get_nested_type(type, i_nested)
        if interrogate_type_is_enum(nested) and not interrogate_type_is_scoped_enum(nested) and interrogate_type_name(nested):
            bind_type(out, nested, bound_templates)

    #for i_method in range(interrogate_type_number_of_make_seqs(type)):
    #    print("list", translateFunctionName(interrogate_make_seq_seq_name(interrogate_type_get_make_seq(type, i_method))), "();", file=out)

    if type_name == "StringStream":
        out.write("func data*(this: StringStream): string {.importcpp: \"nimStringFromStdString(#.get_data())\", header: stringConversionCode.}\n")
        out.write("func `data=`*(this: StringStream, data: string) {.importcpp: \"#.set_data(nimStringToStdString(#))\", header: stringConversionCode.}\n")
        out.write("\n")


def iter_type_tree(type):
    if not is_type_valid(type):
        return

    if interrogate_type_is_wrapped(type) or interrogate_type_is_typedef(type):
        wrapped_type = interrogate_type_wrapped_type(type)
        if not is_type_valid(wrapped_type):
            return
        yield from iter_type_tree(wrapped_type)

    for i_base in range(interrogate_type_number_of_derivations(type)):
        base_type = interrogate_type_get_derivation(type, i_base)
        yield from iter_type_tree(base_type)

    yield type


def iter_module_types(module_name):
    # Yields in sorted order
    returned_types = set()

    for i_type in range(interrogate_number_of_global_types()):
        type = interrogate_get_global_type(i_type)

        for base_type in iter_type_tree(type):
            if interrogate_type_has_module_name(base_type):
                if module_name == interrogate_type_module_name(base_type):
                    if base_type not in returned_types:
                        returned_types.add(base_type)
                        yield base_type


def iter_module_functions(module_name):
    for i_func in range(interrogate_number_of_functions()):
        func = interrogate_get_function(i_func)

        if interrogate_function_has_module_name(func):
            if module_name == interrogate_function_module_name(func):
                yield func


def bind_module(out, module_name):
    print("Generating bindings for %s" % (module_name))

    # Prevent conflicts between type names and properties
    ignore_properties_named = set(("respect_preV_transform",))

    bound_templates = set()

    for type in iter_module_types(module_name):
        ignore_properties_named.add(interrogate_type_name(type))
        bind_type(out, type, bound_templates)

    for type in iter_module_types(module_name):
        for i_element in range(interrogate_type_number_of_elements(type)):
            element = interrogate_type_get_element(type, i_element)
            element_name = interrogate_element_name(element)
            if element_name not in ignore_properties_named:
                bind_property(out, element)
            else:
                print(f"  ignoring property {element_name} due to name conflict")

    for func in iter_module_functions(module_name):
        bind_function(out, func)

    for type in iter_module_types(module_name):
        if interrogate_type_is_struct(type) or interrogate_type_is_class(type):
            element_type = get_type_element_type(type)
            if element_type:
                type_name = translated_type_name(type)
                element_type_name = translated_type_name(element_type)
                out.write(f"iterator items*(collection: {type_name}): {element_type_name} =\n")
                out.write(f"  for i in 0 ..< len(collection):\n")
                out.write(f"    yield collection[i]\n")
                out.write(f"\n")

            if get_type_output_method(type):
                type_name = translated_type_name(type)
                out.write(f"func `$`*(this: {type_name}): string {{.inline.}} =\n")
                out.write(f"  var str : StringStream\n")
                out.write(f"  this.output(str)\n")
                out.write(f"  str.data\n")
                out.write(f"\n")


if __name__ == "__main__":
    # Determine the path to the interrogatedb files
    pandac = os.path.dirname(pandac.__file__)
    interrogate_add_search_directory(os.path.join(pandac, "..", "..", "etc"))
    interrogate_add_search_directory(os.path.join(pandac, "input"))

    import panda3d.core
    with open("panda3d/core.nim", "w") as fp:
        fp.write(CORE_PREAMBLE)
        bind_module(fp, "panda3d.core")
        fp.write(CORE_POSTAMBLE)

    # Determine the suffix for the extension modules.
    if sys.version_info >= (3, 0):
        import _imp
        ext_suffix = _imp.extension_suffixes()[0]
    elif sys.platform == "win32":
        ext_suffix = ".pyd"
    else:
        ext_suffix = ".so"

    for lib in os.listdir(os.path.dirname(panda3d.__file__)):
        if lib.endswith(ext_suffix) and not lib.startswith('core.'):
            module_name = lib[:-len(ext_suffix)]
            if module_name == "_rplight":
                continue

            __import__("panda3d." + module_name)

            with open("panda3d/" + module_name + ".nim", "w") as fp:
                fp.write(OTHER_PREAMBLE % dict(libname="p3" + module_name))
                bind_module(fp, "panda3d." + module_name)
