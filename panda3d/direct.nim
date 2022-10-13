
import ./private
import ./core

when defined(vcc):
  when defined(pandaDir):
    {.passL: "\"" & pandaDir & "/lib/libp3direct.lib\"".}
  else:
    {.passL: "libp3direct.lib".}
else:
  {.passL: "-lp3direct".}

type DCSubatomicType* {.importcpp: "DCSubatomicType", header: "dCSubatomicType.h".} = enum
  ## This defines the numeric type of each element of a DCAtomicField; that is,
  ## the particular values that will get added to the message when the atomic
  ## field method is called.
  ST_int8 = 0
  ST_int16 = 1
  ST_int32 = 2
  ST_int64 = 3
  ST_uint8 = 4
  ST_uint16 = 5
  ST_uint32 = 6
  ST_uint64 = 7
  ST_float64 = 8
  ST_string = 9
  ST_blob = 10
  ST_blob32 = 11
  ST_int16array = 12
  ST_int32array = 13
  ST_uint16array = 14
  ST_uint32array = 15
  ST_int8array = 16
  ST_uint8array = 17
  ST_uint32uint8array = 18
  ST_char = 19
  ST_invalid = 20

type DCPackType* {.importcpp: "DCPackType", header: "dcPackerInterface.h".} = enum
  ## This enumerated type is returned by get_pack_type() and represents the best
  ## choice for a subsequent call to pack_\*() or unpack_\*().
  PT_invalid = 0
  PT_double = 1
  PT_int = 2
  PT_uint = 3
  PT_int64 = 4
  PT_uint64 = 5
  PT_string = 6
  PT_blob = 7
  PT_array = 8
  PT_field = 9
  PT_class = 10
  PT_switch = 11

type DCPackerInterface* {.importcpp: "DCPackerInterface*", bycopy, pure, inheritable, header: "dCPackerInterface.h".} = object
  ## This defines the internal interface for packing values into a DCField.  The
  ## various different DC objects inherit from this.
  ##
  ## Normally these methods are called only by the DCPacker object; the user
  ## wouldn't normally call these directly.

converter toDCPackerInterface*(_: type(nil)): DCPackerInterface {.importcpp: "(nullptr)".}
converter toBool*(this: DCPackerInterface): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCPackerInterface, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type DCKeywordList* {.importcpp: "DCKeywordList", pure, inheritable, header: "dCKeywordList.h".} = object
  ## This is a list of keywords (see DCKeyword) that may be set on a particular
  ## field.

type DCField* {.importcpp: "DCField*", bycopy, pure, inheritable, header: "dCField.h".} = object of DCPackerInterface
  ## A single field of a Distributed Class, either atomic or molecular.

converter toDCField*(_: type(nil)): DCField {.importcpp: "(nullptr)".}
converter toBool*(this: DCField): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCField, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type DCPackData* {.importcpp: "DCPackData", pure, inheritable, header: "dCPackData.h".} = object
  ## This is a block of data that receives the results of DCPacker.

type DCPacker* {.importcpp: "DCPacker", pure, inheritable, header: "dcPacker.h".} = object
  ## This class can be used for packing a series of numeric and string data into
  ## a binary stream, according to the DC specification.
  ##
  ## See also direct/src/doc/dcPacker.txt for a more complete description and
  ## examples of using this class.

type DCParameter* {.importcpp: "DCParameter*", bycopy, pure, inheritable, header: "dCParameter.h".} = object of DCField
  ## Represents the type specification for a single parameter within a field
  ## specification.  This may be a simple type, or it may be a class or an array
  ## reference.
  ##
  ## This may also be a typedef reference to another type, which has the same
  ## properties as the referenced type, but a different name.

converter toDCParameter*(_: type(nil)): DCParameter {.importcpp: "(nullptr)".}
converter toBool*(this: DCParameter): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCParameter, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type DCArrayParameter* {.importcpp: "DCArrayParameter*", bycopy, pure, inheritable, header: "dCArrayParameter.h".} = object of DCParameter
  ## This represents an array of some other kind of object, meaning this
  ## parameter type accepts an arbitrary (or possibly fixed) number of nested
  ## fields, all of which are of the same type.

converter toDCArrayParameter*(_: type(nil)): DCArrayParameter {.importcpp: "(nullptr)".}
converter toBool*(this: DCArrayParameter): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCArrayParameter, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type DCAtomicField* {.importcpp: "DCAtomicField*", bycopy, pure, inheritable, header: "dCAtomicField.h".} = object of DCField
  ## A single atomic field of a Distributed Class, as read from a .dc file.
  ## This defines an interface to the Distributed Class, and is always
  ## implemented as a remote procedure method.

converter toDCAtomicField*(_: type(nil)): DCAtomicField {.importcpp: "(nullptr)".}
converter toBool*(this: DCAtomicField): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCAtomicField, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type DCDeclaration* {.importcpp: "DCDeclaration*", bycopy, pure, inheritable, header: "dCDeclaration.h".} = object
  ## This is a common interface for a declaration in a DC file.  Currently, this
  ## is either a class or a typedef declaration (import declarations are still
  ## collected together at the top, and don't inherit from this object).  Its
  ## only purpose is so that classes and typedefs can be stored in one list
  ## together so they can be ordered correctly on output.

converter toDCDeclaration*(_: type(nil)): DCDeclaration {.importcpp: "(nullptr)".}
converter toBool*(this: DCDeclaration): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCDeclaration, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type DCClass* {.importcpp: "DCClass*", bycopy, pure, inheritable, header: "dCClass.h".} = object of DCDeclaration
  ## Defines a particular DistributedClass as read from an input .dc file.

converter toDCClass*(_: type(nil)): DCClass {.importcpp: "(nullptr)".}
converter toBool*(this: DCClass): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCClass, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type DCClassParameter* {.importcpp: "DCClassParameter", pure, inheritable, header: "dCClassParameter.h".} = object of DCParameter
  ## This represents a class (or struct) object used as a parameter itself.
  ## This means that all the fields of the class get packed into the message.

type DCFile* {.importcpp: "DCFile", pure, inheritable, header: "dCFile.h".} = object
  ## Represents the complete list of Distributed Class descriptions as read from
  ## a .dc file.

type DCKeyword* {.importcpp: "DCKeyword*", bycopy, pure, inheritable, header: "dCKeyword.h".} = object of DCDeclaration
  ## This represents a single keyword declaration in the dc file.  It is used to
  ## define a communication property associated with a field, for instance
  ## "broadcast" or "airecv".

converter toDCKeyword*(_: type(nil)): DCKeyword {.importcpp: "(nullptr)".}
converter toBool*(this: DCKeyword): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCKeyword, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type DCMolecularField* {.importcpp: "DCMolecularField", pure, inheritable, header: "dCMolecularField.h".} = object of DCField
  ## A single molecular field of a Distributed Class, as read from a .dc file.
  ## This represents a combination of two or more related atomic fields, that
  ## will often be treated as a unit.

type DCSimpleParameter* {.importcpp: "DCSimpleParameter", pure, inheritable, header: "dCSimpleParameter.h".} = object of DCParameter
  ## This is the most fundamental kind of parameter type: a single number or
  ## string, one of the DCSubatomicType elements.  It may also optionally have a
  ## divisor, which is meaningful only for the numeric type elements (and
  ## represents a fixed-point numeric convention).

type DCSwitch* {.importcpp: "DCSwitch*", bycopy, pure, inheritable, header: "dCSwitch.h".} = object of DCDeclaration
  ## This represents a switch statement, which can appear inside a class body
  ## and represents two or more alternative unpacking schemes based on the first
  ## field read.

converter toDCSwitch*(_: type(nil)): DCSwitch {.importcpp: "(nullptr)".}
converter toBool*(this: DCSwitch): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCSwitch, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type DCSwitchParameter* {.importcpp: "DCSwitchParameter", pure, inheritable, header: "dCSwitchParameter.h".} = object of DCParameter
  ## This represents a switch object used as a parameter itself, which packs the
  ## appropriate fields of the switch into the message.

type DCTypedef* {.importcpp: "DCTypedef*", bycopy, pure, inheritable, header: "dCTypedef.h".} = object of DCDeclaration
  ## This represents a single typedef declaration in the dc file.  It assigns a
  ## particular type to a new name, just like a C typedef.

converter toDCTypedef*(_: type(nil)): DCTypedef {.importcpp: "(nullptr)".}
converter toBool*(this: DCTypedef): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: DCTypedef, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type SmoothMover* {.importcpp: "SmoothMover", pure, inheritable, header: "smoothMover.h".} = object
  ## This class handles smoothing of sampled motion points over time, e.g.  for
  ## smoothing the apparent movement of remote avatars, whose positions are sent
  ## via occasional telemetry updates.
  ##
  ## It can operate in any of three modes: off, in which it does not smooth any
  ## motion but provides the last position it was told; smoothing only, in which
  ## it smooths motion information but never tries to anticipate where the
  ## avatar might be going; or full prediction, in which it smooths motion as
  ## well as tries to predict the avatar's position in lead of the last position
  ## update.  The assumption is that all SmoothMovers in the world will be
  ## operating in the same mode together.

type SmoothMover_SmoothMode {.importcpp: "SmoothMover::SmoothMode", pure, header: "smoothMover.h".} = enum
  SM_off = 0
  SM_on = 1

template SM_off*(_: typedesc[SmoothMover]): SmoothMover_SmoothMode = SmoothMover_SmoothMode.SM_off
template SM_on*(_: typedesc[SmoothMover]): SmoothMover_SmoothMode = SmoothMover_SmoothMode.SM_on

type SmoothMover_PredictionMode {.importcpp: "SmoothMover::PredictionMode", pure, header: "smoothMover.h".} = enum
  PM_off = 0
  PM_on = 1

template PM_off*(_: typedesc[SmoothMover]): SmoothMover_PredictionMode = SmoothMover_PredictionMode.PM_off
template PM_on*(_: typedesc[SmoothMover]): SmoothMover_PredictionMode = SmoothMover_PredictionMode.PM_on

type CInterval* {.importcpp: "PT(CInterval)", bycopy, pure, inheritable, header: "cInterval.h".} = object of TypedReferenceCount
  ## The base class for timeline components.  A CInterval represents a single
  ## action, event, or collection of nested intervals that will be performed at
  ## some specific time or over a period of time.
  ##
  ## This is essentially similar to the Python "Interval" class, but it is
  ## implemented in C++ (hence the name). Intervals that may be implemented in
  ## C++ will inherit from this class; Intervals that must be implemented in
  ## Python will inherit from the similar Python class.

converter toCInterval*(_: type(nil)): CInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CInterval], obj: TypedObject): CInterval {.importcpp: "DCAST(CInterval, @)".}

type CInterval_EventType {.importcpp: "CInterval::EventType", pure, header: "cInterval.h".} = enum
  ET_initialize = 0
  ET_instant = 1
  ET_step = 2
  ET_finalize = 3
  ET_reverse_initialize = 4
  ET_reverse_instant = 5
  ET_reverse_finalize = 6
  ET_interrupt = 7

template ET_initialize*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_initialize
template ET_instant*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_instant
template ET_step*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_step
template ET_finalize*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_finalize
template ET_reverse_initialize*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_reverse_initialize
template ET_reverse_instant*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_reverse_instant
template ET_reverse_finalize*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_reverse_finalize
template ET_interrupt*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_interrupt

type CInterval_State {.importcpp: "CInterval::State", pure, header: "cInterval.h".} = enum
  S_initial = 0
  S_started = 1
  S_paused = 2
  S_final = 3

template S_initial*(_: typedesc[CInterval]): CInterval_State = CInterval_State.S_initial
template S_started*(_: typedesc[CInterval]): CInterval_State = CInterval_State.S_started
template S_paused*(_: typedesc[CInterval]): CInterval_State = CInterval_State.S_paused
template S_final*(_: typedesc[CInterval]): CInterval_State = CInterval_State.S_final

type CIntervalManager* {.importcpp: "CIntervalManager*", bycopy, pure, inheritable, header: "cIntervalManager.h".} = object
  ## This object holds a number of currently-playing intervals and is
  ## responsible for advancing them each frame as needed.
  ##
  ## There is normally only one IntervalManager object in the world, and it is
  ## the responsibility of the scripting language to call step() on this object
  ## once each frame, and to then process the events indicated by
  ## get_next_event().
  ##
  ## It is also possible to create multiple IntervalManager objects for special
  ## needs.

converter toCIntervalManager*(_: type(nil)): CIntervalManager {.importcpp: "(nullptr)".}
converter toBool*(this: CIntervalManager): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CIntervalManager, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

type CConstraintInterval* {.importcpp: "PT(CConstraintInterval)", bycopy, pure, inheritable, header: "cConstraintInterval.h".} = object of CInterval
  ## The base class for a family of intervals that constrain some property to a
  ## value over time.

converter toCConstraintInterval*(_: type(nil)): CConstraintInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CConstraintInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CConstraintInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CConstraintInterval], obj: TypedObject): CConstraintInterval {.importcpp: "DCAST(CConstraintInterval, @)".}

type CConstrainHprInterval* {.importcpp: "PT(CConstrainHprInterval)", bycopy, pure, inheritable, header: "cConstrainHprInterval.h".} = object of CConstraintInterval
  ## A constraint interval that will constrain the orientation of one node to
  ## the orientation of another.

converter toCConstrainHprInterval*(_: type(nil)): CConstrainHprInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CConstrainHprInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CConstrainHprInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CConstrainHprInterval], obj: TypedObject): CConstrainHprInterval {.importcpp: "DCAST(CConstrainHprInterval, @)".}

type CConstrainPosHprInterval* {.importcpp: "PT(CConstrainPosHprInterval)", bycopy, pure, inheritable, header: "cConstrainPosHprInterval.h".} = object of CConstraintInterval
  ## A constraint interval that will constrain the position and orientation of
  ## one node to the position and orientation of another.

converter toCConstrainPosHprInterval*(_: type(nil)): CConstrainPosHprInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CConstrainPosHprInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CConstrainPosHprInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CConstrainPosHprInterval], obj: TypedObject): CConstrainPosHprInterval {.importcpp: "DCAST(CConstrainPosHprInterval, @)".}

type CConstrainPosInterval* {.importcpp: "PT(CConstrainPosInterval)", bycopy, pure, inheritable, header: "cConstrainPosInterval.h".} = object of CConstraintInterval
  ## A constraint interval that will constrain the position of one node to the
  ## position of another.

converter toCConstrainPosInterval*(_: type(nil)): CConstrainPosInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CConstrainPosInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CConstrainPosInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CConstrainPosInterval], obj: TypedObject): CConstrainPosInterval {.importcpp: "DCAST(CConstrainPosInterval, @)".}

type CConstrainTransformInterval* {.importcpp: "PT(CConstrainTransformInterval)", bycopy, pure, inheritable, header: "cConstrainTransformInterval.h".} = object of CConstraintInterval
  ## A constraint interval that will constrain the transform of one node to the
  ## transform of another.

converter toCConstrainTransformInterval*(_: type(nil)): CConstrainTransformInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CConstrainTransformInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CConstrainTransformInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CConstrainTransformInterval], obj: TypedObject): CConstrainTransformInterval {.importcpp: "DCAST(CConstrainTransformInterval, @)".}

type CLerpInterval* {.importcpp: "PT(CLerpInterval)", bycopy, pure, inheritable, header: "cLerpInterval.h".} = object of CInterval
  ## The base class for a family of intervals that linearly interpolate one or
  ## more numeric values over time.

converter toCLerpInterval*(_: type(nil)): CLerpInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CLerpInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CLerpInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CLerpInterval], obj: TypedObject): CLerpInterval {.importcpp: "DCAST(CLerpInterval, @)".}

type CLerpInterval_BlendType {.importcpp: "CLerpInterval::BlendType", pure, header: "cLerpInterval.h".} = enum
  BT_no_blend = 0
  BT_ease_in = 1
  BT_ease_out = 2
  BT_ease_in_out = 3
  BT_invalid = 4

template BT_no_blend*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_no_blend
template BT_ease_in*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_ease_in
template BT_ease_out*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_ease_out
template BT_ease_in_out*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_ease_in_out
template BT_invalid*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_invalid

type CLerpAnimEffectInterval* {.importcpp: "PT(CLerpAnimEffectInterval)", bycopy, pure, inheritable, header: "cLerpAnimEffectInterval.h".} = object of CLerpInterval
  ## This interval lerps between different amounts of control effects for
  ## various AnimControls that might be playing on an actor.  It's used to
  ## change the blending amount between multiple animations.
  ##
  ## The idea is to start all the animations playing first, then use a
  ## CLerpAnimEffectInterval to adjust the degree to which each animation
  ## affects the actor.

converter toCLerpAnimEffectInterval*(_: type(nil)): CLerpAnimEffectInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CLerpAnimEffectInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CLerpAnimEffectInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CLerpAnimEffectInterval], obj: TypedObject): CLerpAnimEffectInterval {.importcpp: "DCAST(CLerpAnimEffectInterval, @)".}

type CLerpNodePathInterval* {.importcpp: "PT(CLerpNodePathInterval)", bycopy, pure, inheritable, header: "cLerpNodePathInterval.h".} = object of CLerpInterval
  ## An interval that lerps one or more properties (like pos, hpr, etc.) on a
  ## NodePath over time.

converter toCLerpNodePathInterval*(_: type(nil)): CLerpNodePathInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CLerpNodePathInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CLerpNodePathInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CLerpNodePathInterval], obj: TypedObject): CLerpNodePathInterval {.importcpp: "DCAST(CLerpNodePathInterval, @)".}

type CMetaInterval* {.importcpp: "PT(CMetaInterval)", bycopy, pure, inheritable, header: "cMetaInterval.h".} = object of CInterval
  ## This interval contains a list of nested intervals, each of which has its
  ## own begin and end times.  Some of them may overlap and some of them may
  ## not.

converter toCMetaInterval*(_: type(nil)): CMetaInterval {.importcpp: "(nullptr)".}
converter toBool*(this: CMetaInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CMetaInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CMetaInterval], obj: TypedObject): CMetaInterval {.importcpp: "DCAST(CMetaInterval, @)".}

type CMetaInterval_RelativeStart {.importcpp: "CMetaInterval::RelativeStart", pure, header: "cMetaInterval.h".} = enum
  RS_previous_end = 0
  RS_previous_begin = 1
  RS_level_begin = 2

template RS_previous_end*(_: typedesc[CMetaInterval]): CMetaInterval_RelativeStart = CMetaInterval_RelativeStart.RS_previous_end
template RS_previous_begin*(_: typedesc[CMetaInterval]): CMetaInterval_RelativeStart = CMetaInterval_RelativeStart.RS_previous_begin
template RS_level_begin*(_: typedesc[CMetaInterval]): CMetaInterval_RelativeStart = CMetaInterval_RelativeStart.RS_level_begin

type CMetaInterval_DefType {.importcpp: "CMetaInterval::DefType", pure, header: "cMetaInterval.h".} = enum
  DT_c_interval = 0
  DT_ext_index = 1
  DT_push_level = 2
  DT_pop_level = 3

template DT_c_interval*(_: typedesc[CMetaInterval]): CMetaInterval_DefType = CMetaInterval_DefType.DT_c_interval
template DT_ext_index*(_: typedesc[CMetaInterval]): CMetaInterval_DefType = CMetaInterval_DefType.DT_ext_index
template DT_push_level*(_: typedesc[CMetaInterval]): CMetaInterval_DefType = CMetaInterval_DefType.DT_push_level
template DT_pop_level*(_: typedesc[CMetaInterval]): CMetaInterval_DefType = CMetaInterval_DefType.DT_pop_level

type HideInterval* {.importcpp: "PT(HideInterval)", bycopy, pure, inheritable, header: "hideInterval.h".} = object of CInterval
  ## An interval that calls NodePath::hide().

converter toHideInterval*(_: type(nil)): HideInterval {.importcpp: "(nullptr)".}
converter toBool*(this: HideInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: HideInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[HideInterval], obj: TypedObject): HideInterval {.importcpp: "DCAST(HideInterval, @)".}

type LerpBlendType* {.importcpp: "PT(LerpBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of TypedReferenceCount

converter toLerpBlendType*(_: type(nil)): LerpBlendType {.importcpp: "(nullptr)".}
converter toBool*(this: LerpBlendType): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: LerpBlendType, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[LerpBlendType], obj: TypedObject): LerpBlendType {.importcpp: "DCAST(LerpBlendType, @)".}

type EaseInBlendType* {.importcpp: "PT(EaseInBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of LerpBlendType

converter toEaseInBlendType*(_: type(nil)): EaseInBlendType {.importcpp: "(nullptr)".}
converter toBool*(this: EaseInBlendType): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: EaseInBlendType, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[EaseInBlendType], obj: TypedObject): EaseInBlendType {.importcpp: "DCAST(EaseInBlendType, @)".}

type EaseOutBlendType* {.importcpp: "PT(EaseOutBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of LerpBlendType

converter toEaseOutBlendType*(_: type(nil)): EaseOutBlendType {.importcpp: "(nullptr)".}
converter toBool*(this: EaseOutBlendType): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: EaseOutBlendType, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[EaseOutBlendType], obj: TypedObject): EaseOutBlendType {.importcpp: "DCAST(EaseOutBlendType, @)".}

type EaseInOutBlendType* {.importcpp: "PT(EaseInOutBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of LerpBlendType

converter toEaseInOutBlendType*(_: type(nil)): EaseInOutBlendType {.importcpp: "(nullptr)".}
converter toBool*(this: EaseInOutBlendType): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: EaseInOutBlendType, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[EaseInOutBlendType], obj: TypedObject): EaseInOutBlendType {.importcpp: "DCAST(EaseInOutBlendType, @)".}

type NoBlendType* {.importcpp: "PT(NoBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of LerpBlendType

converter toNoBlendType*(_: type(nil)): NoBlendType {.importcpp: "(nullptr)".}
converter toBool*(this: NoBlendType): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: NoBlendType, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[NoBlendType], obj: TypedObject): NoBlendType {.importcpp: "DCAST(NoBlendType, @)".}

type ShowInterval* {.importcpp: "PT(ShowInterval)", bycopy, pure, inheritable, header: "showInterval.h".} = object of CInterval
  ## An interval that calls NodePath::show().

converter toShowInterval*(_: type(nil)): ShowInterval {.importcpp: "(nullptr)".}
converter toBool*(this: ShowInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: ShowInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[ShowInterval], obj: TypedObject): ShowInterval {.importcpp: "DCAST(ShowInterval, @)".}

type WaitInterval* {.importcpp: "PT(WaitInterval)", bycopy, pure, inheritable, header: "waitInterval.h".} = object of CInterval
  ## This interval does absolutely nothing, and is mainly useful for marking
  ## time between other intervals within a sequence.

converter toWaitInterval*(_: type(nil)): WaitInterval {.importcpp: "(nullptr)".}
converter toBool*(this: WaitInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: WaitInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[WaitInterval], obj: TypedObject): WaitInterval {.importcpp: "DCAST(WaitInterval, @)".}

type CConnectionRepository* {.importcpp: "CConnectionRepository", pure, inheritable, header: "cConnectionRepository.h".} = object
  ## This class implements the C++ side of the ConnectionRepository object.  In
  ## particular, it manages the connection to the server once it has been opened
  ## (but does not open it directly).  It manages reading and writing datagrams
  ## on the connection and monitoring for unexpected disconnects as well as
  ## handling intentional disconnects.
  ##
  ## Certain server messages, like field updates, are handled entirely within
  ## the C++ layer, while server messages that are not understood by the C++
  ## layer are returned up to the Python layer for processing.

type CDistributedSmoothNodeBase* {.importcpp: "CDistributedSmoothNodeBase", pure, inheritable, header: "cDistributedSmoothNodeBase.h".} = object
  ## This class defines some basic methods of DistributedSmoothNodeBase which
  ## have been moved into C++ as a performance optimization.

type CMotionTrail* {.importcpp: "PT(CMotionTrail)", bycopy, pure, inheritable, header: "cMotionTrail.h".} = object of TypedReferenceCount
  ## The method used in creating the motion trail is based on taking samples of
  ## time and transformations (the position and orientation matrix) in real-
  ## time.  The method also requires a number of vertices (positions) that
  ## determines "shape" of the motion trail (i.e.  the edge of a blade).  A
  ## start color and end color is also required for each vertex.  The color is
  ## interpolated as function of time.  The colors are typically used to fade
  ## the motion trail so the end color is typically black.
  ##
  ## The vertices are submitted via the "add_vertex" function.  For each frame,
  ## a sample is submited via the "update_motion_trail" function.  During the
  ## "update_motion_trail" function, the motion trail geometry is created
  ## dynamically from the sample history and the vertices.
  ##
  ## The user must specifiy a GeomNode via "set_geom_node".
  ##
  ## The duration of the sample history is specified by a time window.  A larger
  ## time window creates longer motion trails (given constant speed).  Samples
  ## that are no longer within the time window are automatically discarded.
  ##
  ## The nurbs option can be used to create smooth interpolated curves from the
  ## samples.  The nurbs option is useful for animations that lack sampling to
  ## begin with, animations that move very quickly, or low frame rates.
  ##
  ## The texture option be used to create variation to the motion trail.  The u
  ## coordinate of the texture corresponds to time and the v coordinate
  ## corresponds to the "shape" of the motion trail.

converter toCMotionTrail*(_: type(nil)): CMotionTrail {.importcpp: "(nullptr)".}
converter toBool*(this: CMotionTrail): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CMotionTrail, y: type(nil)): bool {.importcpp: "(# == nullptr)".}
func dcast*(_: typedesc[CMotionTrail], obj: TypedObject): CMotionTrail {.importcpp: "DCAST(CMotionTrail, @)".}

func name*(this: CInterval): string {.importcpp: "nimStringFromStdString(#->get_name())", header: stringConversionCode.} ## \
## Returns the interval's name.

func duration*(this: CInterval): float64 {.importcpp: "#->get_duration()".} ## \
## Returns the duration of the interval in seconds.

func openEnded*(this: CInterval): bool {.importcpp: "#->get_open_ended()".} ## \
## Returns the state of the "open_ended" flag.  This is primarily intended for
## instantaneous intervals like FunctionIntervals; it indicates true if the
## interval has some lasting effect that should be applied even if the
## interval doesn't get started until after its finish time, or false if the
## interval is a transitive thing that doesn't need to be called late.

func state*(this: CInterval): CInterval_State {.importcpp: "#->get_state()".} ## \
## Indicates the state the interval believes it is in: whether it has been
## started, is currently in the middle, or has been finalized.

func stopped*(this: CInterval): bool {.importcpp: "#->is_stopped()".} ## \
## Returns true if the interval is in either its initial or final states (but
## not in a running or paused state).

func doneEvent*(this: CInterval): string {.importcpp: "nimStringFromStdString(#->get_done_event())", header: stringConversionCode.} ## \
## Returns the event that is generated whenever the interval reaches its final
## state, whether it is explicitly finished or whether it gets there on its
## own.

proc `doneEvent=`*(this: CInterval, event: string) {.importcpp: "#->set_done_event(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Sets the event that is generated whenever the interval reaches its final
## state, whether it is explicitly finished or whether it gets there on its
## own.

func t*(this: CInterval): float64 {.importcpp: "#->get_t()".} ## \
## Returns the current time of the interval: the last value of t passed to
## priv_initialize(), priv_step(), or priv_finalize().

proc `t=`*(this: CInterval, t: float64) {.importcpp: "#->set_t(#)".} ## \
## Explicitly sets the time within the interval.  Normally, you would use
## start() .. finish() to let the time play normally, but this may be used to
## set the time to some particular value.

func autoPause*(this: CInterval): bool {.importcpp: "#->get_auto_pause()".} ## \
## Returns the state of the 'auto_pause' flag.  See set_auto_pause().

proc `autoPause=`*(this: CInterval, auto_pause: bool) {.importcpp: "#->set_auto_pause(#)".} ## \
## Changes the state of the 'auto_pause' flag.  If this is true, the interval
## may be arbitrarily interrupted when the system needs to reset due to some
## external event by calling CIntervalManager::interrupt().  If this is false
## (the default), the interval must always be explicitly finished or paused.

func autoFinish*(this: CInterval): bool {.importcpp: "#->get_auto_finish()".} ## \
## Returns the state of the 'auto_finish' flag.  See set_auto_finish().

proc `autoFinish=`*(this: CInterval, auto_finish: bool) {.importcpp: "#->set_auto_finish(#)".} ## \
## Changes the state of the 'auto_finish' flag.  If this is true, the interval
## may be arbitrarily finished when the system needs to reset due to some
## external event by calling CIntervalManager::interrupt().  If this is false
## (the default), the interval must always be explicitly finished or paused.

func manager*(this: CInterval): CIntervalManager {.importcpp: "#->get_manager()".} ## \
## Returns the CIntervalManager object which will be responsible for playing
## this interval.  Note that this can only return a C++ object; if the
## particular CIntervalManager object has been extended in the scripting
## language, this will return the encapsulated C++ object, not the full
## extended object.

proc `manager=`*(this: CInterval, manager: CIntervalManager) {.importcpp: "#->set_manager(#)".} ## \
## Indicates the CIntervalManager object which will be responsible for playing
## this interval.  This defaults to the global CIntervalManager; you should
## need to change this only if you have special requirements for playing this
## interval.

func playRate*(this: CInterval): float64 {.importcpp: "#->get_play_rate()".} ## \
## Returns the play rate as set by the last call to start(), loop(), or
## set_play_rate().

proc `playRate=`*(this: CInterval, play_rate: float64) {.importcpp: "#->set_play_rate(#)".} ## \
## Changes the play rate of the interval.  If the interval is already started,
## this changes its speed on-the-fly.  Note that since play_rate is a
## parameter to start() and loop(), the next call to start() or loop() will
## reset this parameter.

func playing*(this: CInterval): bool {.importcpp: "#->is_playing()".} ## \
## Returns true if the interval is currently playing, false otherwise.

proc getName*(this: DCPackerInterface): string {.importcpp: "nimStringFromStdString(#->get_name())", header: stringConversionCode.} ## \
## Returns the name of this field, or empty string if the field is unnamed.

proc findSeekIndex*(this: DCPackerInterface, name: string): int {.importcpp: "#->find_seek_index(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the index number to be passed to a future call to DCPacker::seek()
## to seek directly to the named field without having to look up the field
## name in a table later, or -1 if the named field cannot be found.
##
## If the named field is nested within a switch or some similar dynamic
## structure that reveals different fields based on the contents of the data,
## this mechanism cannot be used to pre-fetch the field index number--you must
## seek for the field by name.

proc asField*(this: DCPackerInterface): DCField {.importcpp: "#->as_field()".}

proc asSwitchParameter*(this: DCPackerInterface): DCSwitchParameter {.importcpp: "#->as_switch_parameter()".}

proc asClassParameter*(this: DCPackerInterface): DCClassParameter {.importcpp: "#->as_class_parameter()".}

proc checkMatch*(this: DCPackerInterface, other: DCPackerInterface): bool {.importcpp: "#->check_match(#)".} ## \
## Returns true if the other interface is bitwise the same as this one--that
## is, a uint32 only matches a uint32, etc.  Names of components, and range
## limits, are not compared.

proc checkMatch*(this: DCPackerInterface, description: string, dcfile: DCFile): bool {.importcpp: "#->check_match(nimStringToStdString(#), #)", header: stringConversionCode.} ## \
## Returns true if this interface is bitwise the same as the interface
## described with the indicated formatted string, e.g.  "(uint8, uint8,
## int16)", or false otherwise.
##
## If DCFile is not NULL, it specifies the DCFile that was previously loaded,
## from which some predefined structs and typedefs may be referenced in the
## description string.

proc checkMatch*(this: DCPackerInterface, description: string): bool {.importcpp: "#->check_match(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns true if this interface is bitwise the same as the interface
## described with the indicated formatted string, e.g.  "(uint8, uint8,
## int16)", or false otherwise.
##
## If DCFile is not NULL, it specifies the DCFile that was previously loaded,
## from which some predefined structs and typedefs may be referenced in the
## description string.

proc hasKeyword*(this: DCKeywordList, keyword: DCKeyword): bool {.importcpp: "#.has_keyword(#)".} ## \
## Returns true if this list includes the indicated keyword, false otherwise.

proc hasKeyword*(this: DCKeywordList, name: string): bool {.importcpp: "#.has_keyword(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns true if this list includes the indicated keyword, false otherwise.

proc getNumKeywords*(this: DCKeywordList): int {.importcpp: "#.get_num_keywords()".} ## \
## Returns the number of keywords in the list.

proc getKeyword*(this: DCKeywordList, n: int): DCKeyword {.importcpp: "#.get_keyword(#)".} ## \
## Returns the nth keyword in the list.

proc getKeywordByName*(this: DCKeywordList, name: string): DCKeyword {.importcpp: "#.get_keyword_by_name(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the keyword in the list with the indicated name, or NULL if there
## is no keyword in the list with that name.

proc compareKeywords*(this: DCKeywordList, other: DCKeywordList): bool {.importcpp: "#.compare_keywords(#)".} ## \
## Returns true if this list has the same keywords as the other list, false if
## some keywords differ.  Order is not considered important.

converter upcastToDCPackerInterface*(this: DCField): DCPackerInterface {.importcpp: "((DCPackerInterface *)(#))".}

converter upcastToDCKeywordList*(this: DCField): DCKeywordList {.importcpp: "((DCKeywordList *)(#))".}

proc getNumber*(this: DCField): int {.importcpp: "#->get_number()".} ## \
## Returns a unique index number associated with this field.  This is defined
## implicitly when the .dc file(s) are read.

proc getClass*(this: DCField): DCClass {.importcpp: "#->get_class()".} ## \
## Returns the DCClass pointer for the class that contains this field.

proc asField*(this: DCField): DCField {.importcpp: "#->as_field()".}

proc asAtomicField*(this: DCField): DCAtomicField {.importcpp: "#->as_atomic_field()".} ## \
## Returns the same field pointer converted to an atomic field pointer, if
## this is in fact an atomic field; otherwise, returns NULL.

proc asMolecularField*(this: DCField): DCMolecularField {.importcpp: "#->as_molecular_field()".} ## \
## Returns the same field pointer converted to a molecular field pointer, if
## this is in fact a molecular field; otherwise, returns NULL.

proc asParameter*(this: DCField): DCParameter {.importcpp: "#->as_parameter()".}

proc hasDefaultValue*(this: DCField): bool {.importcpp: "#->has_default_value()".} ## \
## Returns true if a default value has been explicitly established for this
## field, false otherwise.

proc isBogusField*(this: DCField): bool {.importcpp: "#->is_bogus_field()".} ## \
## Returns true if the field has been flagged as a bogus field.  This is set
## for fields that are generated by the parser as placeholder for missing
## fields, as when reading a partial file; it should not occur in a normal
## valid dc file.

proc isRequired*(this: DCField): bool {.importcpp: "#->is_required()".} ## \
## Returns true if the "required" flag is set for this field, false otherwise.

proc isBroadcast*(this: DCField): bool {.importcpp: "#->is_broadcast()".} ## \
## Returns true if the "broadcast" flag is set for this field, false
## otherwise.

proc isRam*(this: DCField): bool {.importcpp: "#->is_ram()".} ## \
## Returns true if the "ram" flag is set for this field, false otherwise.

proc isDb*(this: DCField): bool {.importcpp: "#->is_db()".} ## \
## Returns true if the "db" flag is set for this field, false otherwise.

proc isClsend*(this: DCField): bool {.importcpp: "#->is_clsend()".} ## \
## Returns true if the "clsend" flag is set for this field, false otherwise.

proc isClrecv*(this: DCField): bool {.importcpp: "#->is_clrecv()".} ## \
## Returns true if the "clrecv" flag is set for this field, false otherwise.

proc isOwnsend*(this: DCField): bool {.importcpp: "#->is_ownsend()".} ## \
## Returns true if the "ownsend" flag is set for this field, false otherwise.

proc isOwnrecv*(this: DCField): bool {.importcpp: "#->is_ownrecv()".} ## \
## Returns true if the "ownrecv" flag is set for this field, false otherwise.

proc isAirecv*(this: DCField): bool {.importcpp: "#->is_airecv()".} ## \
## Returns true if the "airecv" flag is set for this field, false otherwise.

proc output*(this: DCField, `out`: ostream) {.importcpp: "#->output(#)".} ## \
## Write a string representation of this instance to <out>.

proc write*(this: DCField, `out`: ostream, indent_level: int) {.importcpp: "#->write(#, #)".} ## \
## Write a string representation of this instance to <out>.

proc initDCPackData*(): DCPackData {.importcpp: "DCPackData()".}

proc initDCPackData*(param0: DCPackData): DCPackData {.importcpp: "DCPackData(#)".}

proc clear*(this: DCPackData) {.importcpp: "#.clear()".} ## \
## Empties the contents of the data (without necessarily freeing its allocated
## memory).

proc getString*(this: DCPackData): string {.importcpp: "nimStringFromStdString(#.get_string())", header: stringConversionCode.} ## \
## Returns the data buffer as a string.  Also see get_data().

proc getLength*(this: DCPackData): clonglong {.importcpp: "#.get_length()".} ## \
## Returns the current length of the buffer.  This is the number of useful
## bytes stored in the buffer, not the amount of memory it takes up.

proc initDCPacker*(): DCPacker {.importcpp: "DCPacker()".}

proc initDCPacker*(param0: DCPacker): DCPacker {.importcpp: "DCPacker(#)".}

proc clearData*(this: DCPacker) {.importcpp: "#.clear_data()".} ## \
## Empties the data in the pack buffer and unpack buffer.  This should be
## called between calls to begin_pack(), unless you want to concatenate all of
## the pack results together.

proc beginPack*(this: DCPacker, root: DCPackerInterface) {.importcpp: "#.begin_pack(#)".} ## \
## Begins a packing session.  The parameter is the DC object that describes
## the packing format; it may be a DCParameter or DCField.
##
## Unless you call clear_data() between sessions, multiple packing sessions
## will be concatenated together into the same buffer.  If you wish to add
## bytes to the buffer between packing sessions, use append_data() or
## get_write_pointer().

proc endPack*(this: DCPacker): bool {.importcpp: "#.end_pack()".} ## \
## Finishes a packing session.
##
## The return value is true on success, or false if there has been some error
## during packing.

proc beginUnpack*(this: DCPacker, root: DCPackerInterface) {.importcpp: "#.begin_unpack(#)".} ## \
## Begins an unpacking session.  You must have previously called
## set_unpack_data() to specify a buffer to unpack.
##
## If there was data left in the buffer after a previous begin_unpack() ..
## end_unpack() session, the new session will resume from the current point.
## This method may be used, therefore, to unpack a sequence of objects from
## the same buffer.

proc endUnpack*(this: DCPacker): bool {.importcpp: "#.end_unpack()".} ## \
## Finishes the unpacking session.
##
## The return value is true on success, or false if there has been some error
## during unpacking (or if all fields have not been unpacked).

proc beginRepack*(this: DCPacker, root: DCPackerInterface) {.importcpp: "#.begin_repack(#)".} ## \
## Begins a repacking session.  You must have previously called
## set_unpack_data() to specify a buffer to unpack.
##
## Unlike begin_pack() or begin_unpack() you may not concatenate the results
## of multiple begin_repack() sessions in one buffer.
##
## Also, unlike in packing or unpacking modes, you may not walk through the
## fields from beginning to end, or even pack two consecutive fields at once.
## Instead, you must call seek() for each field you wish to modify and pack
## only that one field; then call seek() again to modify another field.

proc endRepack*(this: DCPacker): bool {.importcpp: "#.end_repack()".} ## \
## Finishes the repacking session.
##
## The return value is true on success, or false if there has been some error
## during repacking (or if all fields have not been repacked).

proc seek*(this: DCPacker, seek_index: int): bool {.importcpp: "#.seek(#)".} ## \
## Seeks to the field indentified by seek_index, which was returned by an
## earlier call to DCField::find_seek_index() to get the index of some nested
## field.  Also see the version of seek() that accepts a field name.
##
## Returns true if successful, false if the field is not known (or if the
## packer is in an invalid mode).

proc seek*(this: DCPacker, field_name: string): bool {.importcpp: "#.seek(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Sets the current unpack (or repack) position to the named field.  In unpack
## mode, the next call to unpack_\*() or push() will begin to read the named
## field.  In repack mode, the next call to pack_\*() or push() will modify the
## named field.
##
## Returns true if successful, false if the field is not known (or if the
## packer is in an invalid mode).

proc hasNestedFields*(this: DCPacker): bool {.importcpp: "#.has_nested_fields()".} ## \
## Returns true if the current field has any nested fields (and thus expects a
## push() .. pop() interface), or false otherwise.  If this returns true,
## get_num_nested_fields() may be called to determine how many nested fields
## are expected.

proc getNumNestedFields*(this: DCPacker): int {.importcpp: "#.get_num_nested_fields()".} ## \
## Returns the number of nested fields associated with the current field, if
## has_nested_fields() returned true.
##
## The return value may be -1 to indicate that a variable number of nested
## fields are accepted by this field type (e.g.  a variable-length array).
##
## Note that this method is unreliable to determine how many fields you must
## traverse before you can call pop(), since particularly in the presence of a
## DCSwitch, it may change during traversal.  Use more_nested_fields()
## instead.

proc moreNestedFields*(this: DCPacker): bool {.importcpp: "#.more_nested_fields()".} ## \
## Returns true if there are more nested fields to pack or unpack in the
## current push sequence, false if it is time to call pop().

proc getCurrentParent*(this: DCPacker): DCPackerInterface {.importcpp: "#.get_current_parent()".} ## \
## Returns the field that we left in our last call to push(): the owner of the
## current level of fields.  This may be NULL at the beginning of the pack
## operation.

proc getCurrentField*(this: DCPacker): DCPackerInterface {.importcpp: "#.get_current_field()".} ## \
## Returns the field that will be referenced by the next call to pack_\*() or
## unpack_\*().  This will be NULL if we have unpacked (or packed) all fields,
## or if it is time to call pop().

proc getLastSwitch*(this: DCPacker): DCSwitchParameter {.importcpp: "#.get_last_switch()".} ## \
## Returns a pointer to the last DCSwitch instance that we have passed by and
## selected one case of during the pack/unpack process.  Each time we
## encounter a new DCSwitch and select a case, this will change state.
##
## This may be used to detect when a DCSwitch has been selected.  At the
## moment this changes state, get_current_parent() will contain the particular
## SwitchCase that was selected by the switch.

proc getPackType*(this: DCPacker): DCPackType {.importcpp: "#.get_pack_type()".} ## \
## Returns the type of value expected by the current field.  See the
## enumerated type definition at the top of DCPackerInterface.h.  If this
## returns one of PT_double, PT_int, PT_int64, or PT_string, then you should
## call the corresponding pack_double(), pack_int() function (or
## unpack_double(), unpack_int(), etc.) to transfer data.  Otherwise, you
## should call push() and begin packing or unpacking the nested fields.

proc getCurrentFieldName*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.get_current_field_name())", header: stringConversionCode.} ## \
## Returns the name of the current field, if it has a name, or the empty
## string if the field does not have a name or there is no current field.

proc push*(this: DCPacker) {.importcpp: "#.push()".} ## \
## Marks the beginning of a nested series of fields.
##
## This must be called before filling the elements of an array or the
## individual fields in a structure field.  It must also be balanced by a
## matching pop().
##
## It is necessary to use push() / pop() only if has_nested_fields() returns
## true.

proc pop*(this: DCPacker) {.importcpp: "#.pop()".} ## \
## Marks the end of a nested series of fields.
##
## This must be called to match a previous push() only after all the expected
## number of nested fields have been packed.  It is an error to call it too
## early, or too late.

proc packDouble*(this: DCPacker, value: float64) {.importcpp: "#.pack_double(#)".} ## \
## Packs the indicated numeric or string value into the stream.

proc packInt*(this: DCPacker, value: int) {.importcpp: "#.pack_int(#)".} ## \
## Packs the indicated numeric or string value into the stream.

proc packUint*(this: DCPacker, value: int) {.importcpp: "#.pack_uint(#)".} ## \
## Packs the indicated numeric or string value into the stream.

proc packInt64*(this: DCPacker, value: clonglong) {.importcpp: "#.pack_int64(#)".} ## \
## Packs the indicated numeric or string value into the stream.

proc packUint64*(this: DCPacker, value: clonglong) {.importcpp: "#.pack_uint64(#)".} ## \
## Packs the indicated numeric or string value into the stream.

proc packString*(this: DCPacker, value: string) {.importcpp: "#.pack_string(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Packs the indicated numeric or string value into the stream.

proc packDefaultValue*(this: DCPacker) {.importcpp: "#.pack_default_value()".} ## \
## Adds the default value for the current element into the stream.  If no
## default has been set for the current element, creates a sensible default.

proc unpackDouble*(this: DCPacker): float64 {.importcpp: "#.unpack_double()".} ## \
## Unpacks the current numeric or string value from the stream.

proc unpackInt*(this: DCPacker): int {.importcpp: "#.unpack_int()".} ## \
## Unpacks the current numeric or string value from the stream.

proc unpackUint*(this: DCPacker): int {.importcpp: "#.unpack_uint()".} ## \
## Unpacks the current numeric or string value from the stream.

proc unpackInt64*(this: DCPacker): clonglong {.importcpp: "#.unpack_int64()".} ## \
## Unpacks the current numeric or string value from the stream.

proc unpackUint64*(this: DCPacker): clonglong {.importcpp: "#.unpack_uint64()".} ## \
## Unpacks the current numeric or string value from the stream.

proc unpackString*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.unpack_string())", header: stringConversionCode.} ## \
## Unpacks the current numeric or string value from the stream.

proc unpackValidate*(this: DCPacker) {.importcpp: "#.unpack_validate()".} ## \
## Internally unpacks the current numeric or string value and validates it
## against the type range limits, but does not return the value.  If the
## current field contains nested fields, validates all of them.

proc unpackSkip*(this: DCPacker) {.importcpp: "#.unpack_skip()".} ## \
## Skips the current field without unpacking it and advances to the next
## field.  If the current field contains nested fields, skips all of them.

proc parseAndPack*(this: DCPacker, `in`: istream): bool {.importcpp: "#.parse_and_pack(#)".} ## \
## Parses an object's value according to the DC file syntax (e.g.  as a
## default value string) and packs it.  Returns true on success, false on a
## parse error.

proc parseAndPack*(this: DCPacker, formatted_object: string): bool {.importcpp: "#.parse_and_pack(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Parses an object's value according to the DC file syntax (e.g.  as a
## default value string) and packs it.  Returns true on success, false on a
## parse error.

proc unpackAndFormat*(this: DCPacker, show_field_names: bool): string {.importcpp: "nimStringFromStdString(#.unpack_and_format(#))", header: stringConversionCode.} ## \
## Unpacks an object and formats its value into a syntax suitable for parsing
## in the dc file (e.g.  as a default value), or as an input to parse_object.

proc unpackAndFormat*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.unpack_and_format())", header: stringConversionCode.} ## \
## Unpacks an object and formats its value into a syntax suitable for parsing
## in the dc file (e.g.  as a default value), or as an input to parse_object.

proc unpackAndFormat*(this: DCPacker, `out`: ostream, show_field_names: bool) {.importcpp: "#.unpack_and_format(#, #)".} ## \
## Unpacks an object and formats its value into a syntax suitable for parsing
## in the dc file (e.g.  as a default value), or as an input to parse_object.

proc unpackAndFormat*(this: DCPacker, `out`: ostream) {.importcpp: "#.unpack_and_format(#)".} ## \
## Unpacks an object and formats its value into a syntax suitable for parsing
## in the dc file (e.g.  as a default value), or as an input to parse_object.

proc hadParseError*(this: DCPacker): bool {.importcpp: "#.had_parse_error()".} ## \
## Returns true if there has been an parse error since the most recent call to
## begin(); this can only happen if you call parse_and_pack().

proc hadPackError*(this: DCPacker): bool {.importcpp: "#.had_pack_error()".} ## \
## Returns true if there has been an packing error since the most recent call
## to begin(); in particular, this may be called after end() has returned
## false to determine the nature of the failure.
##
## A return value of true indicates there was a push/pop mismatch, or the
## push/pop structure did not match the data structure, or there were the
## wrong number of elements in a nested push/pop structure, or on unpack that
## the data stream was truncated.

proc hadRangeError*(this: DCPacker): bool {.importcpp: "#.had_range_error()".} ## \
## Returns true if there has been an range validation error since the most
## recent call to begin(); in particular, this may be called after end() has
## returned false to determine the nature of the failure.
##
## A return value of true indicates a value that was packed or unpacked did
## not fit within the specified legal range for a parameter, or within the
## limits of the field size.

proc hadError*(this: DCPacker): bool {.importcpp: "#.had_error()".} ## \
## Returns true if there has been any error (either a pack error or a range
## error) since the most recent call to begin().  If this returns true, then
## the matching call to end() will indicate an error (false).

proc getNumUnpackedBytes*(this: DCPacker): clonglong {.importcpp: "#.get_num_unpacked_bytes()".} ## \
## Returns the number of bytes that have been unpacked so far, or after
## unpack_end(), the total number of bytes that were unpacked at all.  This
## can be used to validate that all of the bytes in the buffer were actually
## unpacked (which is not otherwise considered an error).

proc getLength*(this: DCPacker): clonglong {.importcpp: "#.get_length()".} ## \
## Returns the current length of the buffer.  This is the number of useful
## bytes stored in the buffer, not the amount of memory it takes up.

proc getString*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.get_string())", header: stringConversionCode.} ## \
## Returns the packed data buffer as a string.  Also see get_data().

proc getUnpackLength*(this: DCPacker): clonglong {.importcpp: "#.get_unpack_length()".} ## \
## Returns the total number of bytes in the unpack data buffer.  This is the
## buffer used when unpacking; it is separate from the pack data returned by
## get_length(), which is filled during packing.

proc getUnpackString*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.get_unpack_string())", header: stringConversionCode.} ## \
## Returns the unpack data buffer, as a string.  This is the buffer used when
## unpacking; it is separate from the pack data returned by get_string(),
## which is filled during packing.  Also see get_unpack_data().

proc getNumStackElementsEverAllocated*(_: typedesc[DCPacker]): int {.importcpp: "DCPacker::get_num_stack_elements_ever_allocated()", header: "dcPacker.h".} ## \
## Returns the number of DCPacker::StackElement pointers ever simultaneously
## allocated; these are now either in active use or have been recycled into
## the deleted DCPacker::StackElement pool to be used again.

proc rawPackInt8*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_int8(#)".} ## \
## Packs the data into the buffer between packing sessions.

proc rawPackInt16*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_int16(#)".} ## \
## Packs the data into the buffer between packing sessions.

proc rawPackInt32*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_int32(#)".} ## \
## Packs the data into the buffer between packing sessions.

proc rawPackInt64*(this: DCPacker, value: clonglong) {.importcpp: "#.raw_pack_int64(#)".} ## \
## Packs the data into the buffer between packing sessions.

proc rawPackUint8*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_uint8(#)".} ## \
## Packs the data into the buffer between packing sessions.

proc rawPackUint16*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_uint16(#)".} ## \
## Packs the data into the buffer between packing sessions.

proc rawPackUint32*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_uint32(#)".} ## \
## Packs the data into the buffer between packing sessions.

proc rawPackUint64*(this: DCPacker, value: clonglong) {.importcpp: "#.raw_pack_uint64(#)".} ## \
## Packs the data into the buffer between packing sessions.

proc rawPackFloat64*(this: DCPacker, value: float64) {.importcpp: "#.raw_pack_float64(#)".} ## \
## Packs the data into the buffer between packing sessions.

proc rawPackString*(this: DCPacker, value: string) {.importcpp: "#.raw_pack_string(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Packs the data into the buffer between packing sessions.

proc rawUnpackInt8*(this: DCPacker): int {.importcpp: "#.raw_unpack_int8()".} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc rawUnpackInt16*(this: DCPacker): int {.importcpp: "#.raw_unpack_int16()".} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc rawUnpackInt32*(this: DCPacker): int {.importcpp: "#.raw_unpack_int32()".} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc rawUnpackInt64*(this: DCPacker): clonglong {.importcpp: "#.raw_unpack_int64()".} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc rawUnpackUint8*(this: DCPacker): int {.importcpp: "#.raw_unpack_uint8()".} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc rawUnpackUint16*(this: DCPacker): int {.importcpp: "#.raw_unpack_uint16()".} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc rawUnpackUint32*(this: DCPacker): int {.importcpp: "#.raw_unpack_uint32()".} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc rawUnpackUint64*(this: DCPacker): clonglong {.importcpp: "#.raw_unpack_uint64()".} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc rawUnpackFloat64*(this: DCPacker): float64 {.importcpp: "#.raw_unpack_float64()".} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc rawUnpackString*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.raw_unpack_string())", header: stringConversionCode.} ## \
## Unpacks the data from the buffer between unpacking sessions.

proc asSimpleParameter*(this: DCParameter): DCSimpleParameter {.importcpp: "#->as_simple_parameter()".}

proc asArrayParameter*(this: DCParameter): DCArrayParameter {.importcpp: "#->as_array_parameter()".}

proc makeCopy*(this: DCParameter): DCParameter {.importcpp: "#->make_copy()".}

proc isValid*(this: DCParameter): bool {.importcpp: "#->is_valid()".}

proc getTypedef*(this: DCParameter): DCTypedef {.importcpp: "#->get_typedef()".} ## \
## If this type has been referenced from a typedef, returns the DCTypedef
## instance, or NULL if the type was declared on-the-fly.

proc getElementType*(this: DCArrayParameter): DCParameter {.importcpp: "#->get_element_type()".} ## \
## Returns the type of the individual elements of this array.

proc getArraySize*(this: DCArrayParameter): int {.importcpp: "#->get_array_size()".} ## \
## Returns the fixed number of elements in this array, or -1 if the array may
## contain a variable number of elements.

proc getNumElements*(this: DCAtomicField): int {.importcpp: "#->get_num_elements()".} ## \
## Returns the number of elements (parameters) of the atomic field.

proc getElement*(this: DCAtomicField, n: int): DCParameter {.importcpp: "#->get_element(#)".} ## \
## Returns the parameter object describing the nth element.

proc hasElementDefault*(this: DCAtomicField, n: int): bool {.importcpp: "#->has_element_default(#)".} ## \
## Returns true if the nth element of the field has a default value specified,
## false otherwise.
##
## @deprecated use get_element() instead.

proc getElementName*(this: DCAtomicField, n: int): string {.importcpp: "nimStringFromStdString(#->get_element_name(#))", header: stringConversionCode.} ## \
## Returns the name of the nth element of the field.  This name is strictly
## for documentary purposes; it does not generally affect operation.  If a
## name is not specified, this will be the empty string.
##
## @deprecated use get_element()->get_name() instead.

proc getElementType*(this: DCAtomicField, n: int): DCSubatomicType {.importcpp: "#->get_element_type(#)".} ## \
## Returns the numeric type of the nth element of the field.  This method is
## deprecated; use get_element() instead.

proc getElementDivisor*(this: DCAtomicField, n: int): int {.importcpp: "#->get_element_divisor(#)".} ## \
## Returns the divisor associated with the nth element of the field.  This
## implements an implicit fixed-point system; floating-point values are to be
## multiplied by this value before encoding into a packet, and divided by this
## number after decoding.
##
## This method is deprecated; use get_element()->get_divisor() instead.

proc asClass*(this: DCDeclaration): DCClass {.importcpp: "#->as_class()".}

proc asSwitch*(this: DCDeclaration): DCSwitch {.importcpp: "#->as_switch()".}

proc output*(this: DCDeclaration, `out`: ostream) {.importcpp: "#->output(#)".} ## \
## Write a string representation of this instance to <out>.

proc write*(this: DCDeclaration, `out`: ostream, indent_level: int) {.importcpp: "#->write(#, #)".} ## \
## Write a string representation of this instance to <out>.

proc getDcFile*(this: DCClass): DCFile {.importcpp: "#->get_dc_file()".} ## \
## Returns the DCFile object that contains the class.

proc getName*(this: DCClass): string {.importcpp: "nimStringFromStdString(#->get_name())", header: stringConversionCode.} ## \
## Returns the name of this class.

proc getNumber*(this: DCClass): int {.importcpp: "#->get_number()".} ## \
## Returns a unique index number associated with this class.  This is defined
## implicitly when the .dc file(s) are read.

proc getNumParents*(this: DCClass): int {.importcpp: "#->get_num_parents()".} ## \
## Returns the number of base classes this class inherits from.

proc getParent*(this: DCClass, n: int): DCClass {.importcpp: "#->get_parent(#)".} ## \
## Returns the nth parent class this class inherits from.

proc hasConstructor*(this: DCClass): bool {.importcpp: "#->has_constructor()".} ## \
## Returns true if this class has a constructor method, false if it just uses
## the default constructor.

proc getConstructor*(this: DCClass): DCField {.importcpp: "#->get_constructor()".} ## \
## Returns the constructor method for this class if it is defined, or NULL if
## the class uses the default constructor.

proc getNumFields*(this: DCClass): int {.importcpp: "#->get_num_fields()".} ## \
## Returns the number of fields defined directly in this class, ignoring
## inheritance.

proc getField*(this: DCClass, n: int): DCField {.importcpp: "#->get_field(#)".} ## \
## Returns the nth field in the class.  This is not necessarily the field with
## index n; this is the nth field defined in the class directly, ignoring
## inheritance.

proc getFieldByName*(this: DCClass, name: string): DCField {.importcpp: "#->get_field_by_name(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns a pointer to the DCField that shares the indicated name.  If the
## named field is not found in the current class, the parent classes will be
## searched, so the value returned may not actually be a field within this
## class.  Returns NULL if there is no such field defined.

proc getFieldByIndex*(this: DCClass, index_number: int): DCField {.importcpp: "#->get_field_by_index(#)".} ## \
## Returns a pointer to the DCField that has the indicated index number.  If
## the numbered field is not found in the current class, the parent classes
## will be searched, so the value returned may not actually be a field within
## this class.  Returns NULL if there is no such field defined.

proc getNumInheritedFields*(this: DCClass): int {.importcpp: "#->get_num_inherited_fields()".} ## \
## Returns the total number of field fields defined in this class and all
## ancestor classes.

proc getInheritedField*(this: DCClass, n: int): DCField {.importcpp: "#->get_inherited_field(#)".} ## \
## Returns the nth field field in the class and all of its ancestors.
##
## This \*used\* to be the same thing as get_field_by_index(), back when the
## fields were numbered sequentially within a class's inheritance hierarchy.
## Now that fields have a globally unique index number, this is no longer
## true.

proc isStruct*(this: DCClass): bool {.importcpp: "#->is_struct()".} ## \
## Returns true if the class has been identified with the "struct" keyword in
## the dc file, false if it was declared with "dclass".

proc isBogusClass*(this: DCClass): bool {.importcpp: "#->is_bogus_class()".} ## \
## Returns true if the class has been flagged as a bogus class.  This is set
## for classes that are generated by the parser as placeholder for missing
## classes, as when reading a partial file; it should not occur in a normal
## valid dc file.

proc inheritsFromBogusClass*(this: DCClass): bool {.importcpp: "#->inherits_from_bogus_class()".} ## \
## Returns true if this class, or any class in the inheritance heirarchy for
## this class, is a "bogus" class--a forward reference to an as-yet-undefined
## class.

proc startGenerate*(this: DCClass) {.importcpp: "#->start_generate()".} ## \
## Starts the PStats timer going on the "generate" task, that is, marks the
## beginning of the process of generating a new object, for the purposes of
## timing this process.
##
## This should balance with a corresponding call to stop_generate().

proc stopGenerate*(this: DCClass) {.importcpp: "#->stop_generate()".} ## \
## Stops the PStats timer on the "generate" task.  This should balance with a
## preceding call to start_generate().

proc output*(this: DCClass, `out`: ostream) {.importcpp: "#->output(#)".} ## \
## Write a string representation of this instance to <out>.

proc hasClassDef*(this: DCClass): bool {.importcpp: "#->has_class_def()".} ## \
## Returns true if the DCClass object has an associated Python class
## definition, false otherwise.

proc hasOwnerClassDef*(this: DCClass): bool {.importcpp: "#->has_owner_class_def()".} ## \
## Returns true if the DCClass object has an associated Python owner class
## definition, false otherwise.

proc getClass*(this: DCClassParameter): DCClass {.importcpp: "#.get_class()".} ## \
## Returns the class object this parameter represents.

proc initDCFile*(): DCFile {.importcpp: "DCFile()".}

proc initDCFile*(param0: DCFile): DCFile {.importcpp: "DCFile(#)".}

proc clear*(this: DCFile) {.importcpp: "#.clear()".} ## \
## Removes all of the classes defined within the DCFile and prepares it for
## reading a new file.

proc readAll*(this: DCFile): bool {.importcpp: "#.read_all()".} ## \
## This special method reads all of the .dc files named by the "dc-file"
## config.prc variable, and loads them into the DCFile namespace.

proc read*(this: DCFile, filename: Filename): bool {.importcpp: "#.read(#)".} ## \
## Opens and reads the indicated .dc file by name.  The distributed classes
## defined in the file will be appended to the set of distributed classes
## already recorded, if any.
##
## Returns true if the file is successfully read, false if there was an error
## (in which case the file might have been partially read).

proc read*(this: DCFile, `in`: istream, filename: string): bool {.importcpp: "#.read(#, nimStringToStdString(#))", header: stringConversionCode.} ## \
## Parses the already-opened input stream for distributed class descriptions.
## The filename parameter is optional and is only used when reporting errors.
##
## The distributed classes defined in the file will be appended to the set of
## distributed classes already recorded, if any.
##
## Returns true if the file is successfully read, false if there was an error
## (in which case the file might have been partially read).

proc read*(this: DCFile, `in`: istream): bool {.importcpp: "#.read(#)".} ## \
## Parses the already-opened input stream for distributed class descriptions.
## The filename parameter is optional and is only used when reporting errors.
##
## The distributed classes defined in the file will be appended to the set of
## distributed classes already recorded, if any.
##
## Returns true if the file is successfully read, false if there was an error
## (in which case the file might have been partially read).

proc write*(this: DCFile, filename: Filename, brief: bool): bool {.importcpp: "#.write(#, #)".} ## \
## Opens the indicated filename for output and writes a parseable description
## of all the known distributed classes to the file.
##
## Returns true if the description is successfully written, false otherwise.

proc write*(this: DCFile, `out`: ostream, brief: bool): bool {.importcpp: "#.write(#, #)".} ## \
## Writes a parseable description of all the known distributed classes to the
## stream.
##
## Returns true if the description is successfully written, false otherwise.

proc getNumClasses*(this: DCFile): int {.importcpp: "#.get_num_classes()".} ## \
## Returns the number of classes read from the .dc file(s).

proc getClass*(this: DCFile, n: int): DCClass {.importcpp: "#.get_class(#)".} ## \
## Returns the nth class read from the .dc file(s).

proc getClassByName*(this: DCFile, name: string): DCClass {.importcpp: "#.get_class_by_name(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the class that has the indicated name, or NULL if there is no such
## class.

proc getSwitchByName*(this: DCFile, name: string): DCSwitch {.importcpp: "#.get_switch_by_name(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the switch that has the indicated name, or NULL if there is no such
## switch.

proc getFieldByIndex*(this: DCFile, index_number: int): DCField {.importcpp: "#.get_field_by_index(#)".} ## \
## Returns a pointer to the one DCField that has the indicated index number,
## of all the DCFields across all classes in the file.
##
## This method is only valid if dc-multiple-inheritance is set true in the
## Config.prc file.  Without this setting, different DCFields may share the
## same index number, so this global lookup is not possible.

proc allObjectsValid*(this: DCFile): bool {.importcpp: "#.all_objects_valid()".} ## \
## Returns true if all of the classes read from the DC file were defined and
## valid, or false if any of them were undefined ("bogus classes").  If this
## is true, we might have read a partial file.

proc getNumImportModules*(this: DCFile): int {.importcpp: "#.get_num_import_modules()".} ## \
## Returns the number of import lines read from the .dc file(s).

proc getImportModule*(this: DCFile, n: int): string {.importcpp: "nimStringFromStdString(#.get_import_module(#))", header: stringConversionCode.} ## \
## Returns the module named by the nth import line read from the .dc file(s).

proc getNumImportSymbols*(this: DCFile, n: int): int {.importcpp: "#.get_num_import_symbols(#)".} ## \
## Returns the number of symbols explicitly imported by the nth import line.
## If this is 0, the line is "import modulename"; if it is more than 0, the
## line is "from modulename import symbol, symbol ... ".

proc getImportSymbol*(this: DCFile, n: int, i: int): string {.importcpp: "nimStringFromStdString(#.get_import_symbol(#, #))", header: stringConversionCode.} ## \
## Returns the ith symbol named by the nth import line read from the .dc
## file(s).

proc getNumTypedefs*(this: DCFile): int {.importcpp: "#.get_num_typedefs()".} ## \
## Returns the number of typedefs read from the .dc file(s).

proc getTypedef*(this: DCFile, n: int): DCTypedef {.importcpp: "#.get_typedef(#)".} ## \
## Returns the nth typedef read from the .dc file(s).

proc getTypedefByName*(this: DCFile, name: string): DCTypedef {.importcpp: "#.get_typedef_by_name(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the typedef that has the indicated name, or NULL if there is no
## such typedef name.

proc getNumKeywords*(this: DCFile): int {.importcpp: "#.get_num_keywords()".} ## \
## Returns the number of keywords read from the .dc file(s).

proc getKeyword*(this: DCFile, n: int): DCKeyword {.importcpp: "#.get_keyword(#)".} ## \
## Returns the nth keyword read from the .dc file(s).

proc getKeywordByName*(this: DCFile, name: string): DCKeyword {.importcpp: "#.get_keyword_by_name(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the keyword that has the indicated name, or NULL if there is no
## such keyword name.

proc getHash*(this: DCFile): int {.importcpp: "#.get_hash()".} ## \
## Returns a 32-bit hash index associated with this file.  This number is
## guaranteed to be consistent if the contents of the file have not changed,
## and it is very likely to be different if the contents of the file do
## change.

proc getName*(this: DCKeyword): string {.importcpp: "nimStringFromStdString(#->get_name())", header: stringConversionCode.} ## \
## Returns the name of this keyword.

proc getNumAtomics*(this: DCMolecularField): int {.importcpp: "#.get_num_atomics()".} ## \
## Returns the number of atomic fields that make up this molecular field.

proc getAtomic*(this: DCMolecularField, n: int): DCAtomicField {.importcpp: "#.get_atomic(#)".} ## \
## Returns the nth atomic field that makes up this molecular field.  This may
## or may not be a field of this particular class; it might be defined in a
## parent class.

proc getType*(this: DCSimpleParameter): DCSubatomicType {.importcpp: "#.get_type()".} ## \
## Returns the particular subatomic type represented by this instance.

proc hasModulus*(this: DCSimpleParameter): bool {.importcpp: "#.has_modulus()".} ## \
## Returns true if there is a modulus associated, false otherwise.,

proc getModulus*(this: DCSimpleParameter): float64 {.importcpp: "#.get_modulus()".} ## \
## Returns the modulus associated with this type, if any.  It is an error to
## call this if has_modulus() returned false.
##
## If present, this is the modulus that is used to constrain the numeric value
## of the field before it is packed (and range-checked).

proc getDivisor*(this: DCSimpleParameter): int {.importcpp: "#.get_divisor()".} ## \
## Returns the divisor associated with this type.  This is 1 by default, but
## if this is other than one it represents the scale to apply when packing and
## unpacking numeric values (to store fixed-point values in an integer field).
## It is only meaningful for numeric-type fields.

proc getName*(this: DCSwitch): string {.importcpp: "nimStringFromStdString(#->get_name())", header: stringConversionCode.} ## \
## Returns the name of this switch.

proc getKeyParameter*(this: DCSwitch): DCField {.importcpp: "#->get_key_parameter()".} ## \
## Returns the key parameter on which the switch is based.  The value of this
## parameter in the record determines which one of the several cases within
## the switch will be used.

proc getNumCases*(this: DCSwitch): int {.importcpp: "#->get_num_cases()".} ## \
## Returns the number of different cases within the switch.  The legal values
## for case_index range from 0 to get_num_cases() - 1.

proc getCase*(this: DCSwitch, n: int): DCPackerInterface {.importcpp: "#->get_case(#)".} ## \
## Returns the DCPackerInterface that packs the nth case.

proc getDefaultCase*(this: DCSwitch): DCPackerInterface {.importcpp: "#->get_default_case()".} ## \
## Returns the DCPackerInterface that packs the default case, or NULL if there
## is no default case.

proc getNumFields*(this: DCSwitch, case_index: int): int {.importcpp: "#->get_num_fields(#)".} ## \
## Returns the number of fields in the indicated case.

proc getField*(this: DCSwitch, case_index: int, n: int): DCField {.importcpp: "#->get_field(#, #)".} ## \
## Returns the nth field in the indicated case.

proc getFieldByName*(this: DCSwitch, case_index: int, name: string): DCField {.importcpp: "#->get_field_by_name(#, nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the field with the given name from the indicated case, or NULL if
## no field has this name.

proc getSwitch*(this: DCSwitchParameter): DCSwitch {.importcpp: "#.get_switch()".} ## \
## Returns the switch object this parameter represents.

proc getNumber*(this: DCTypedef): int {.importcpp: "#->get_number()".} ## \
## Returns a unique index number associated with this typedef definition.
## This is defined implicitly when the .dc file(s) are read.

proc getName*(this: DCTypedef): string {.importcpp: "nimStringFromStdString(#->get_name())", header: stringConversionCode.} ## \
## Returns the name of this typedef.

proc getDescription*(this: DCTypedef): string {.importcpp: "nimStringFromStdString(#->get_description())", header: stringConversionCode.} ## \
## Returns a brief decription of the typedef, useful for human consumption.

proc isBogusTypedef*(this: DCTypedef): bool {.importcpp: "#->is_bogus_typedef()".} ## \
## Returns true if the typedef has been flagged as a bogus typedef.  This is
## set for typedefs that are generated by the parser as placeholder for
## missing typedefs, as when reading a partial file; it should not occur in a
## normal valid dc file.

proc isImplicitTypedef*(this: DCTypedef): bool {.importcpp: "#->is_implicit_typedef()".} ## \
## Returns true if the typedef has been flagged as an implicit typedef,
## meaning it was created for a DCClass that was referenced inline as a type.

proc getParticlePath*(): ConfigVariableSearchPath {.importcpp: "get_particle_path()".}

proc throwNewFrame*() {.importcpp: "throw_new_frame()".}

proc initAppForGui*() {.importcpp: "init_app_for_gui()".}

proc addFullscreenTestsize*(xsize: int, ysize: int) {.importcpp: "add_fullscreen_testsize(#, #)".} ## \
## klunky interface since we cant pass array from python->C++

proc runtestFullscreenSizes*(win: GraphicsWindow) {.importcpp: "runtest_fullscreen_sizes(#)".}

proc queryFullscreenTestresult*(xsize: int, ysize: int): bool {.importcpp: "query_fullscreen_testresult(#, #)".}

proc storeAccessibilityShortcutKeys*() {.importcpp: "store_accessibility_shortcut_keys()".} ## \
## to handle windows stickykeys

proc allowAccessibilityShortcutKeys*(allowKeys: bool) {.importcpp: "allow_accessibility_shortcut_keys(#)".}

proc initSmoothMover*(): SmoothMover {.importcpp: "SmoothMover()".}

proc initSmoothMover*(param0: SmoothMover): SmoothMover {.importcpp: "SmoothMover(#)".}

proc setPos*(this: SmoothMover, pos: LVecBase3): bool {.importcpp: "#.set_pos((LVecBase3 &)(#))".} ## \
## Specifies the position of the SmoothMover at a particular time in the past.
## When mark_position() is called, this will be recorded (along with hpr and
## timestamp) in a position report, which will then be used along with all
## other position reports to determine the smooth position at any particular
## instant.
##
## The return value is true if any parameter has changed since the last call
## to set_pos(), or false if they are the same.

proc setPos*(this: SmoothMover, x: float32, y: float32, z: float32): bool {.importcpp: "#.set_pos(#, #, #)".} ## \
## Specifies the position of the SmoothMover at a particular time in the past.
## When mark_position() is called, this will be recorded (along with hpr and
## timestamp) in a position report, which will then be used along with all
## other position reports to determine the smooth position at any particular
## instant.
##
## The return value is true if any parameter has changed since the last call
## to set_pos(), or false if they are the same.

proc setX*(this: SmoothMover, x: float32): bool {.importcpp: "#.set_x(#)".} ## \
## Sets the X position only.  See set_pos().

proc setY*(this: SmoothMover, y: float32): bool {.importcpp: "#.set_y(#)".} ## \
## Sets the Y position only.  See set_pos().

proc setZ*(this: SmoothMover, z: float32): bool {.importcpp: "#.set_z(#)".} ## \
## Sets the Z position only.  See set_pos().

proc setHpr*(this: SmoothMover, hpr: LVecBase3): bool {.importcpp: "#.set_hpr((LVecBase3 &)(#))".} ## \
## Specifies the orientation of the SmoothMover at a particular time in the
## past.  When mark_position() is called, this will be recorded (along with
## hpr and timestamp) in a position report, which will then be used along with
## all other position reports to determine the smooth position at any
## particular instant.
##
## The return value is true if any parameter has changed since the last call
## to set_hpr(), or false if they are the same.

proc setHpr*(this: SmoothMover, h: float32, p: float32, r: float32): bool {.importcpp: "#.set_hpr(#, #, #)".} ## \
## Specifies the orientation of the SmoothMover at a particular time in the
## past.  When mark_position() is called, this will be recorded (along with
## hpr and timestamp) in a position report, which will then be used along with
## all other position reports to determine the smooth position at any
## particular instant.
##
## The return value is true if any parameter has changed since the last call
## to set_hpr(), or false if they are the same.

proc setH*(this: SmoothMover, h: float32): bool {.importcpp: "#.set_h(#)".} ## \
## Sets the heading only.  See set_hpr().

proc setP*(this: SmoothMover, p: float32): bool {.importcpp: "#.set_p(#)".} ## \
## Sets the pitch only.  See set_hpr().

proc setR*(this: SmoothMover, r: float32): bool {.importcpp: "#.set_r(#)".} ## \
## Sets the roll only.  See set_hpr().

proc setPosHpr*(this: SmoothMover, pos: LVecBase3, hpr: LVecBase3): bool {.importcpp: "#.set_pos_hpr((LVecBase3 &)(#), (LVecBase3 &)(#))".} ## \
## Specifies the position and orientation of the SmoothMover at a particular
## time in the past.  When mark_position() is called, this will be recorded
## (along with timestamp) in a position report, which will then be used along
## with all other position reports to determine the smooth position at any
## particular instant.
##
## The return value is true if any parameter has changed since the last call
## to set_pos_hpr(), or false if they are the same.

proc setPosHpr*(this: SmoothMover, x: float32, y: float32, z: float32, h: float32, p: float32, r: float32): bool {.importcpp: "#.set_pos_hpr(#, #, #, #, #, #)".} ## \
## Specifies the position of the SmoothMover at a particular time in the past.
## When mark_position() is called, this will be recorded (along with
## timestamp) in a position report, which will then be used along with all
## other position reports to determine the smooth position at any particular
## instant.
##
## The return value is true if any parameter has changed since the last call
## to set_pos_hpr(), or false if they are the same.

proc getSamplePos*(this: SmoothMover): LPoint3 {.importcpp: "#.get_sample_pos()".} ## \
## Returns the current position of the working sample point.  This position is
## updated periodically by set_x(), set_y(), etc., and its current value is
## copied to the sample point table when mark_position() is called.

proc getSampleHpr*(this: SmoothMover): LVecBase3 {.importcpp: "#.get_sample_hpr()".} ## \
## Returns the current orientation of the working sample point.  This
## orientation is updated periodically by set_h(), set_p(), etc., and its
## current value is copied to the sample point table when mark_position() is
## called.

proc setPhonyTimestamp*(this: SmoothMover, timestamp: float64, period_adjust: bool) {.importcpp: "#.set_phony_timestamp(#, #)".} ## \
## Lies and specifies that the current position report was received now.  This
## is usually used for very old position reports for which we're not sure of
## the actual receipt time.

proc setPhonyTimestamp*(this: SmoothMover, timestamp: float64) {.importcpp: "#.set_phony_timestamp(#)".} ## \
## Lies and specifies that the current position report was received now.  This
## is usually used for very old position reports for which we're not sure of
## the actual receipt time.

proc setPhonyTimestamp*(this: SmoothMover) {.importcpp: "#.set_phony_timestamp()".} ## \
## Lies and specifies that the current position report was received now.  This
## is usually used for very old position reports for which we're not sure of
## the actual receipt time.

proc setTimestamp*(this: SmoothMover, timestamp: float64) {.importcpp: "#.set_timestamp(#)".} ## \
## Specifies the time that the current position report applies.  This should
## be called, along with set_pos() and set_hpr(), before a call to
## mark_position().

proc hasMostRecentTimestamp*(this: SmoothMover): bool {.importcpp: "#.has_most_recent_timestamp()".} ## \
## Returns true if we have most recently recorded timestamp

proc getMostRecentTimestamp*(this: SmoothMover): float64 {.importcpp: "#.get_most_recent_timestamp()".} ## \
## Returns most recently recorded timestamp

proc markPosition*(this: SmoothMover) {.importcpp: "#.mark_position()".} ## \
## Stores the position, orientation, and timestamp (if relevant) indicated by
## previous calls to set_pos(), set_hpr(), and set_timestamp() in a new
## position report.
##
## When compute_smooth_position() is called, it uses these stored position
## reports to base its computation of the known position.

proc clearPositions*(this: SmoothMover, reset_velocity: bool) {.importcpp: "#.clear_positions(#)".} ## \
## Erases all the old position reports.  This should be done, for instance,
## prior to teleporting the avatar to a new position; otherwise, the smoother
## might try to lerp the avatar there.  If reset_velocity is true, the
## velocity is also reset to 0.

proc computeSmoothPosition*(this: SmoothMover): bool {.importcpp: "#.compute_smooth_position()".} ## \
## Computes the smoothed position (and orientation) of the mover at the
## indicated point in time, based on the previous position reports.  After
## this call has been made, get_smooth_pos() etc.  may be called to retrieve
## the smoothed position.
##
## With no parameter, the function uses ClockObject::get_frame_time() as the
## default time.

proc computeSmoothPosition*(this: SmoothMover, timestamp: float64): bool {.importcpp: "#.compute_smooth_position(#)".} ## \
## Computes the smoothed position (and orientation) of the mover at the
## indicated point in time, based on the previous position reports.  After
## this call has been made, get_smooth_pos() etc.  may be called to retrieve
## the smoothed position.
##
## The return value is true if the value has changed (or might have changed)
## since the last call to compute_smooth_position(), or false if it remains
## the same.

proc getLatestPosition*(this: SmoothMover): bool {.importcpp: "#.get_latest_position()".} ## \
## Updates the smooth_pos (and smooth_hpr, etc.) members to reflect the
## absolute latest position known for this avatar.  This may result in a pop
## to the most recent position.
##
## Returns true if the latest position is known, false otherwise.

proc getSmoothPos*(this: SmoothMover): LPoint3 {.importcpp: "#.get_smooth_pos()".} ## \
## Returns the smoothed position as computed by a previous call to
## compute_smooth_position().

proc getSmoothHpr*(this: SmoothMover): LVecBase3 {.importcpp: "#.get_smooth_hpr()".} ## \
## Returns the smoothed orientation as computed by a previous call to
## compute_smooth_position().

proc applySmoothPos*(this: SmoothMover, node: NodePath) {.importcpp: "#.apply_smooth_pos(#)".} ## \
## Applies the smoothed position to the indicated NodePath.  This is
## equivalent to calling node.set_pos(smooth_mover->get_smooth_pos()).  It
## exists as an optimization only, to avoid the overhead of passing the return
## value through Python.

proc applySmoothPosHpr*(this: SmoothMover, pos_node: NodePath, hpr_node: NodePath) {.importcpp: "#.apply_smooth_pos_hpr(#, #)".} ## \
## Applies the smoothed position and orientation to the indicated NodePath.
## This is equivalent to calling
## node.set_pos_hpr(smooth_mover->get_smooth_pos(),
## smooth_mover->get_smooth_hpr()).  It exists as an optimization only, to
## avoid the overhead of passing the return value through Python.

proc applySmoothHpr*(this: SmoothMover, node: NodePath) {.importcpp: "#.apply_smooth_hpr(#)".} ## \
## Applies the smoothed orientation to the indicated NodePath.  This is
## equivalent to calling node.set_hpr(smooth_mover->get_smooth_hpr()).  It
## exists as an optimization only, to avoid the overhead of passing the return
## value through Python.

proc computeAndApplySmoothPos*(this: SmoothMover, node: NodePath) {.importcpp: "#.compute_and_apply_smooth_pos(#)".} ## \
## A further optimization to reduce Python calls.  This computes the smooth
## position and applies it to the indicated node in one call.

proc computeAndApplySmoothPosHpr*(this: SmoothMover, pos_node: NodePath, hpr_node: NodePath) {.importcpp: "#.compute_and_apply_smooth_pos_hpr(#, #)".} ## \
## A further optimization to reduce Python calls.  This computes the smooth
## position and applies it to the indicated node or nodes in one call.  The
## pos_node and hpr_node might be the same NodePath.

proc computeAndApplySmoothHpr*(this: SmoothMover, hpr_node: NodePath) {.importcpp: "#.compute_and_apply_smooth_hpr(#)".} ## \
## A further optimization to reduce Python calls.  This computes the smooth
## position and applies it to the indicated node or nodes in one call.  The
## pos_node and hpr_node might be the same NodePath.

proc getSmoothForwardVelocity*(this: SmoothMover): float32 {.importcpp: "#.get_smooth_forward_velocity()".} ## \
## Returns the speed at which the avatar is moving, in feet per second, along
## its own forward axis (after applying the avatar's hpr).  This will be a
## positive number if the avatar is moving forward, and a negative number if
## it is moving backward.

proc getSmoothLateralVelocity*(this: SmoothMover): float32 {.importcpp: "#.get_smooth_lateral_velocity()".} ## \
## Returns the speed at which the avatar is moving, in feet per second, along
## its own lateral axis (after applying the avatar's hpr).  This will be a
## positive number if the avatar is moving right, and a negative number if it
## is moving left.

proc getSmoothRotationalVelocity*(this: SmoothMover): float32 {.importcpp: "#.get_smooth_rotational_velocity()".} ## \
## Returns the speed at which the avatar is rotating in the horizontal plane
## (i.e.  heading), in degrees per second.  This may be positive or negative,
## according to the direction of rotation.

proc getForwardAxis*(this: SmoothMover): LVecBase3 {.importcpp: "#.get_forward_axis()".} ## \
## Returns the smoothed position as computed by a previous call to
## compute_smooth_position().

proc handleWrtReparent*(this: SmoothMover, old_parent: NodePath, new_parent: NodePath) {.importcpp: "#.handle_wrt_reparent(#, #)".} ## \
## Node is being wrtReparented, update recorded sample positions to reflect
## new parent

proc setSmoothMode*(this: SmoothMover, mode: SmoothMover_SmoothMode) {.importcpp: "#.set_smooth_mode(#)".} ## \
## Sets the smoothing mode of all SmoothMovers in the world.  If this is
## SM_off, no smoothing or prediction will be performed, and get_smooth_pos()
## will simply return the position last set by mark_position().

proc getSmoothMode*(this: SmoothMover): SmoothMover_SmoothMode {.importcpp: "#.get_smooth_mode()".} ## \
## Returns the smoothing mode of all SmoothMovers in the world.  See
## set_smooth_mode().

proc setPredictionMode*(this: SmoothMover, mode: SmoothMover_PredictionMode) {.importcpp: "#.set_prediction_mode(#)".} ## \
## Sets the predictioning mode of all SmoothMovers in the world.  If this is
## PM_off, no prediction will be performed, but smoothing might still be
## performed.

proc getPredictionMode*(this: SmoothMover): SmoothMover_PredictionMode {.importcpp: "#.get_prediction_mode()".} ## \
## Returns the predictioning mode of all SmoothMovers in the world.  See
## set_prediction_mode().

proc setDelay*(this: SmoothMover, delay: float64) {.importcpp: "#.set_delay(#)".} ## \
## Sets the amount of time, in seconds, to delay the computed position of a
## SmoothMover.  This is particularly useful when the prediction mode is off,
## because it can allow the apparent motion of an avatar to appear smooth
## without relying on prediction, at the cost of introducing additional lag in
## the avatar's apparent position.

proc getDelay*(this: SmoothMover): float64 {.importcpp: "#.get_delay()".} ## \
## Returns the amount of time, in seconds, to delay the computed position of a
## SmoothMover.  See set_delay().

proc setAcceptClockSkew*(this: SmoothMover, flag: bool) {.importcpp: "#.set_accept_clock_skew(#)".} ## \
## Sets the 'accept clock skew' flag.  When this flag is true, clock skew from
## the other clients will be tolerated by delaying each smooth mover's
## position an additional amount, on top of that specified by set_delay(),
## based on the measured average latency for timestamp messages received by
## the client.
##
## In this way, if the other client has significant clock skew with respect to
## our clock, it will be evident as a large positive or negative average
## latency for timestamps.  By subtracting out this average latency, we
## compensate for poor clock sync.

proc getAcceptClockSkew*(this: SmoothMover): bool {.importcpp: "#.get_accept_clock_skew()".} ## \
## Returns the current state of the 'accept clock skew' flag.  See
## set_accept_clock_skew().

proc setMaxPositionAge*(this: SmoothMover, age: float64) {.importcpp: "#.set_max_position_age(#)".} ## \
## Sets the maximum amount of time a position is allowed to remain unchanged
## before assuming it represents the avatar actually standing still.

proc getMaxPositionAge*(this: SmoothMover): float64 {.importcpp: "#.get_max_position_age()".} ## \
## Returns the maximum amount of time a position is allowed to remain
## unchanged before assuming it represents the avatar actually standing still.

proc setExpectedBroadcastPeriod*(this: SmoothMover, period: float64) {.importcpp: "#.set_expected_broadcast_period(#)".} ## \
## Sets the interval at which we expect the SmoothNodes to broadcast their
## position, in elapsed seconds.  This controls the length of time we assume
## the object has truly stopped, when we receive a long sequence of no
## updates.

proc getExpectedBroadcastPeriod*(this: SmoothMover): float64 {.importcpp: "#.get_expected_broadcast_period()".} ## \
## Returns the interval at which we expect the SmoothNodes to broadcast their
## position, in elapsed seconds.  See set_expected_broadcast_period().

proc setResetVelocityAge*(this: SmoothMover, age: float64) {.importcpp: "#.set_reset_velocity_age(#)".} ## \
## Sets the amount of time that should elapse after the last position report
## before the velocity is reset to 0.  This is similar to max_position_age,
## but it is only used to determine the resetting of the reported velocity.
## It should always be greater than or equal to max_position_age.

proc getResetVelocityAge*(this: SmoothMover): float64 {.importcpp: "#.get_reset_velocity_age()".} ## \
## Returns the amount of time that should elapse after the last position
## report before the velocity is reset to 0.  See set_reset_velocity_age().

proc setDirectionalVelocity*(this: SmoothMover, flag: bool) {.importcpp: "#.set_directional_velocity(#)".} ## \
## Sets the flag that indicates whether the avatar's direction is considered
## in computing the velocity.  When this is true, velocity is automatically
## decomposed into a forward and a lateral velocity (and both may be positive
## or negative); when it is false, all velocity is always returned as forward
## velocity (and it is always positive).

proc getDirectionalVelocity*(this: SmoothMover): bool {.importcpp: "#.get_directional_velocity()".} ## \
## Returns the current state of the 'directional velocity' flag.  See
## set_directional_velocity().

proc setDefaultToStandingStill*(this: SmoothMover, flag: bool) {.importcpp: "#.set_default_to_standing_still(#)".} ## \
## Sets the flag that indicates whether to assume that the node stopped moving
## during periods when we don't get enough position updates.  If true, the
## object will stand still momentarily.  If false, the object will
## continuously lerp between the position updates that we did get.

proc getDefaultToStandingStill*(this: SmoothMover): bool {.importcpp: "#.get_default_to_standing_still()".} ## \
## Returns the current state of the 'default to standing still' flag.  See
## set_default_to_standing_still().

proc output*(this: SmoothMover, `out`: ostream) {.importcpp: "#.output(#)".}

proc write*(this: SmoothMover, `out`: ostream) {.importcpp: "#.write(#)".}

proc getName*(this: CInterval): string {.importcpp: "nimStringFromStdString(#->get_name())", header: stringConversionCode.} ## \
## Returns the interval's name.

proc getDuration*(this: CInterval): float64 {.importcpp: "#->get_duration()".} ## \
## Returns the duration of the interval in seconds.

proc getOpenEnded*(this: CInterval): bool {.importcpp: "#->get_open_ended()".} ## \
## Returns the state of the "open_ended" flag.  This is primarily intended for
## instantaneous intervals like FunctionIntervals; it indicates true if the
## interval has some lasting effect that should be applied even if the
## interval doesn't get started until after its finish time, or false if the
## interval is a transitive thing that doesn't need to be called late.

proc getState*(this: CInterval): CInterval_State {.importcpp: "#->get_state()".} ## \
## Indicates the state the interval believes it is in: whether it has been
## started, is currently in the middle, or has been finalized.

proc isStopped*(this: CInterval): bool {.importcpp: "#->is_stopped()".} ## \
## Returns true if the interval is in either its initial or final states (but
## not in a running or paused state).

proc setDoneEvent*(this: CInterval, event: string) {.importcpp: "#->set_done_event(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Sets the event that is generated whenever the interval reaches its final
## state, whether it is explicitly finished or whether it gets there on its
## own.

proc getDoneEvent*(this: CInterval): string {.importcpp: "nimStringFromStdString(#->get_done_event())", header: stringConversionCode.} ## \
## Returns the event that is generated whenever the interval reaches its final
## state, whether it is explicitly finished or whether it gets there on its
## own.

proc setT*(this: CInterval, t: float64) {.importcpp: "#->set_t(#)".} ## \
## Explicitly sets the time within the interval.  Normally, you would use
## start() .. finish() to let the time play normally, but this may be used to
## set the time to some particular value.

proc getT*(this: CInterval): float64 {.importcpp: "#->get_t()".} ## \
## Returns the current time of the interval: the last value of t passed to
## priv_initialize(), priv_step(), or priv_finalize().

proc setAutoPause*(this: CInterval, auto_pause: bool) {.importcpp: "#->set_auto_pause(#)".} ## \
## Changes the state of the 'auto_pause' flag.  If this is true, the interval
## may be arbitrarily interrupted when the system needs to reset due to some
## external event by calling CIntervalManager::interrupt().  If this is false
## (the default), the interval must always be explicitly finished or paused.

proc getAutoPause*(this: CInterval): bool {.importcpp: "#->get_auto_pause()".} ## \
## Returns the state of the 'auto_pause' flag.  See set_auto_pause().

proc setAutoFinish*(this: CInterval, auto_finish: bool) {.importcpp: "#->set_auto_finish(#)".} ## \
## Changes the state of the 'auto_finish' flag.  If this is true, the interval
## may be arbitrarily finished when the system needs to reset due to some
## external event by calling CIntervalManager::interrupt().  If this is false
## (the default), the interval must always be explicitly finished or paused.

proc getAutoFinish*(this: CInterval): bool {.importcpp: "#->get_auto_finish()".} ## \
## Returns the state of the 'auto_finish' flag.  See set_auto_finish().

proc setWantsTCallback*(this: CInterval, wants_t_callback: bool) {.importcpp: "#->set_wants_t_callback(#)".} ## \
## Changes the state of the 'wants_t_callback' flag.  If this is true, the
## interval will be returned by CIntervalManager::get_event() each time the
## interval's time value has been changed, regardless of whether it has any
## external events.

proc getWantsTCallback*(this: CInterval): bool {.importcpp: "#->get_wants_t_callback()".} ## \
## Returns the state of the 'wants_t_callback' flag.  See
## set_wants_t_callback().

proc setManager*(this: CInterval, manager: CIntervalManager) {.importcpp: "#->set_manager(#)".} ## \
## Indicates the CIntervalManager object which will be responsible for playing
## this interval.  This defaults to the global CIntervalManager; you should
## need to change this only if you have special requirements for playing this
## interval.

proc getManager*(this: CInterval): CIntervalManager {.importcpp: "#->get_manager()".} ## \
## Returns the CIntervalManager object which will be responsible for playing
## this interval.  Note that this can only return a C++ object; if the
## particular CIntervalManager object has been extended in the scripting
## language, this will return the encapsulated C++ object, not the full
## extended object.

proc start*(this: CInterval, start_t: float64, end_t: float64, play_rate: float64) {.importcpp: "#->start(#, #, #)".} ## \
## Starts the interval playing by registering it with the current
## CIntervalManager.  The interval will play to the end and stop.
##
## If end_t is less than zero, it indicates the end of the interval.

proc start*(this: CInterval, start_t: float64, end_t: float64) {.importcpp: "#->start(#, #)".} ## \
## Starts the interval playing by registering it with the current
## CIntervalManager.  The interval will play to the end and stop.
##
## If end_t is less than zero, it indicates the end of the interval.

proc start*(this: CInterval, start_t: float64) {.importcpp: "#->start(#)".} ## \
## Starts the interval playing by registering it with the current
## CIntervalManager.  The interval will play to the end and stop.
##
## If end_t is less than zero, it indicates the end of the interval.

proc start*(this: CInterval) {.importcpp: "#->start()".} ## \
## Starts the interval playing by registering it with the current
## CIntervalManager.  The interval will play to the end and stop.
##
## If end_t is less than zero, it indicates the end of the interval.

proc loop*(this: CInterval, start_t: float64, end_t: float64, play_rate: float64) {.importcpp: "#->loop(#, #, #)".} ## \
## Starts the interval playing by registering it with the current
## CIntervalManager.  The interval will play until it is interrupted with
## finish() or pause(), looping back to start_t when it reaches end_t.
##
## If end_t is less than zero, it indicates the end of the interval.

proc loop*(this: CInterval, start_t: float64, end_t: float64) {.importcpp: "#->loop(#, #)".} ## \
## Starts the interval playing by registering it with the current
## CIntervalManager.  The interval will play until it is interrupted with
## finish() or pause(), looping back to start_t when it reaches end_t.
##
## If end_t is less than zero, it indicates the end of the interval.

proc loop*(this: CInterval, start_t: float64) {.importcpp: "#->loop(#)".} ## \
## Starts the interval playing by registering it with the current
## CIntervalManager.  The interval will play until it is interrupted with
## finish() or pause(), looping back to start_t when it reaches end_t.
##
## If end_t is less than zero, it indicates the end of the interval.

proc loop*(this: CInterval) {.importcpp: "#->loop()".} ## \
## Starts the interval playing by registering it with the current
## CIntervalManager.  The interval will play until it is interrupted with
## finish() or pause(), looping back to start_t when it reaches end_t.
##
## If end_t is less than zero, it indicates the end of the interval.

proc pause*(this: CInterval): float64 {.importcpp: "#->pause()".} ## \
## Stops the interval from playing but leaves it in its current state.  It may
## later be resumed from this point by calling resume().

proc resume*(this: CInterval) {.importcpp: "#->resume()".} ## \
## Restarts the interval from its current point after a previous call to
## pause().

proc resume*(this: CInterval, start_t: float64) {.importcpp: "#->resume(#)".} ## \
## Restarts the interval from the indicated point after a previous call to
## pause().

proc resumeUntil*(this: CInterval, end_t: float64) {.importcpp: "#->resume_until(#)".} ## \
## Restarts the interval from the current point after a previous call to
## pause() (or a previous play-to-point-and-stop), to play until the indicated
## point and then stop.

proc finish*(this: CInterval) {.importcpp: "#->finish()".} ## \
## Stops the interval from playing and sets it to its final state.

proc clearToInitial*(this: CInterval) {.importcpp: "#->clear_to_initial()".} ## \
## Pauses the interval, if it is playing, and resets its state to its initial
## state, abandoning any state changes already in progress in the middle of
## the interval.  Calling this is like pausing the interval and discarding it,
## creating a new one in its place.

proc isPlaying*(this: CInterval): bool {.importcpp: "#->is_playing()".} ## \
## Returns true if the interval is currently playing, false otherwise.

proc getPlayRate*(this: CInterval): float64 {.importcpp: "#->get_play_rate()".} ## \
## Returns the play rate as set by the last call to start(), loop(), or
## set_play_rate().

proc setPlayRate*(this: CInterval, play_rate: float64) {.importcpp: "#->set_play_rate(#)".} ## \
## Changes the play rate of the interval.  If the interval is already started,
## this changes its speed on-the-fly.  Note that since play_rate is a
## parameter to start() and loop(), the next call to start() or loop() will
## reset this parameter.

proc privDoEvent*(this: CInterval, t: float64, event: CInterval_EventType) {.importcpp: "#->priv_do_event(#, #)".} ## \
## These cannot be declared private because they must be accessible to
## Python, but the method names are prefixed with priv_ to remind you that
## you probably don't want to be using them directly.

proc privInitialize*(this: CInterval, t: float64) {.importcpp: "#->priv_initialize(#)".} ## \
## This replaces the first call to priv_step(), and indicates that the
## interval has just begun.  This may be overridden by derived classes that
## need to do some explicit initialization on the first call.

proc privInstant*(this: CInterval) {.importcpp: "#->priv_instant()".} ## \
## This is called in lieu of priv_initialize() .. priv_step() ..
## priv_finalize(), when everything is to happen within one frame.  The
## interval should initialize itself, then leave itself in the final state.

proc privStep*(this: CInterval, t: float64) {.importcpp: "#->priv_step(#)".} ## \
## Advances the time on the interval.  The time may either increase (the
## normal case) or decrease (e.g.  if the interval is being played by a
## slider).

proc privFinalize*(this: CInterval) {.importcpp: "#->priv_finalize()".} ## \
## This is called to stop an interval, forcing it to whatever state it would
## be after it played all the way through.  It's generally invoked by
## set_final_t().

proc privReverseInitialize*(this: CInterval, t: float64) {.importcpp: "#->priv_reverse_initialize(#)".} ## \
## Similar to priv_initialize(), but this is called when the interval is being
## played backwards; it indicates that the interval should start at the
## finishing state and undo any intervening intervals.

proc privReverseInstant*(this: CInterval) {.importcpp: "#->priv_reverse_instant()".} ## \
## This is called in lieu of priv_reverse_initialize() .. priv_step() ..
## priv_reverse_finalize(), when everything is to happen within one frame.
## The interval should initialize itself, then leave itself in the initial
## state.

proc privReverseFinalize*(this: CInterval) {.importcpp: "#->priv_reverse_finalize()".} ## \
## Called generally following a priv_reverse_initialize(), this indicates the
## interval should set itself to the initial state.

proc privInterrupt*(this: CInterval) {.importcpp: "#->priv_interrupt()".} ## \
## This is called while the interval is playing to indicate that it is about
## to be interrupted; that is, priv_step() will not be called for a length of
## time.  But the interval should remain in its current state in anticipation
## of being eventually restarted when the calls to priv_step() eventually
## resume.
##
## The purpose of this function is to allow self-running intervals like sound
## intervals to stop the actual sound playback during the pause.

proc output*(this: CInterval, `out`: ostream) {.importcpp: "#->output(#)".}

proc write*(this: CInterval, `out`: ostream, indent_level: int) {.importcpp: "#->write(#, #)".}

proc setupPlay*(this: CInterval, start_time: float64, end_time: float64, play_rate: float64, do_loop: bool) {.importcpp: "#->setup_play(#, #, #, #)".} ## \
## Called to prepare the interval for automatic timed playback, e.g.  via a
## Python task.  The interval will be played from start_t to end_t, at a time
## factor specified by play_rate.  start_t must always be less than end_t
## (except for the exception for end_t == -1, below), but if play_rate is
## negative the interval will be played backwards.
##
## Specify end_t of -1 to play the entire interval from start_t.
##
## Call step_play() repeatedly to execute the interval.

proc setupResume*(this: CInterval) {.importcpp: "#->setup_resume()".} ## \
## Called to prepare the interval for restarting at the current point within
## the interval after an interruption.

proc setupResumeUntil*(this: CInterval, end_t: float64) {.importcpp: "#->setup_resume_until(#)".} ## \
## Called to prepare the interval for restarting from the current point after
## a previous call to pause() (or a previous play-to-point-and-stop), to play
## until the indicated point and then stop.

proc stepPlay*(this: CInterval): bool {.importcpp: "#->step_play()".} ## \
## Should be called once per frame to execute the automatic timed playback
## begun with setup_play().
##
## Returns true if the interval should continue, false if it is done and
## should stop.

proc newCIntervalManager*(): CIntervalManager {.importcpp: "new CIntervalManager()".}

proc setEventQueue*(this: CIntervalManager, event_queue: EventQueue) {.importcpp: "#->set_event_queue(#)".} ## \
## Specifies a custom event queue to be used for throwing done events from
## intervals as they finish.  If this is not specified, the global event queue
## is used.
##
## The caller maintains ownership of the EventQueue object; it is the caller's
## responsibility to ensure that the supplied EventQueue does not destruct
## during the lifetime of the CIntervalManager.

proc getEventQueue*(this: CIntervalManager): EventQueue {.importcpp: "#->get_event_queue()".} ## \
## Returns the custom event queue to be used for throwing done events from
## intervals as they finish.

proc addCInterval*(this: CIntervalManager, interval: CInterval, external: bool): int {.importcpp: "#->add_c_interval(#, #)".} ## \
## Adds the interval to the manager, and returns a unique index for the
## interval.  This index will be unique among all the currently added
## intervals, but not unique across all intervals ever added to the manager.
## The maximum index value will never exceed the maximum number of intervals
## added at any given time.
##
## If the external flag is true, the interval is understood to also be stored
## in the scripting language data structures.  In this case, it will be
## available for information returned by get_next_event() and
## get_next_removal().  If external is false, the interval's index will never
## be returned by these two functions.

proc findCInterval*(this: CIntervalManager, name: string): int {.importcpp: "#->find_c_interval(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the index associated with the named interval, if there is such an
## interval, or -1 if there is not.

proc getCInterval*(this: CIntervalManager, index: int): CInterval {.importcpp: "#->get_c_interval(#)".} ## \
## Returns the interval associated with the given index.

proc removeCInterval*(this: CIntervalManager, index: int) {.importcpp: "#->remove_c_interval(#)".} ## \
## Removes the indicated interval from the queue immediately.  It will not be
## returned from get_next_removal(), and none of its pending events, if any,
## will be returned by get_next_event().

proc interrupt*(this: CIntervalManager): int {.importcpp: "#->interrupt()".} ## \
## Pauses or finishes (removes from the active queue) all intervals tagged
## with auto_pause or auto_finish set to true.  These are intervals that
## someone fired up but won't necessarily expect to clean up; they can be
## interrupted at will when necessary.
##
## Returns the number of intervals affected.

proc getNumIntervals*(this: CIntervalManager): int {.importcpp: "#->get_num_intervals()".} ## \
## Returns the number of currently active intervals.

proc getMaxIndex*(this: CIntervalManager): int {.importcpp: "#->get_max_index()".} ## \
## Returns one more than the largest interval index number in the manager.  If
## you walk through all the values between (0, get_max_index()] and call
## get_c_interval() on each number, you will retrieve all of the managed
## intervals (and possibly a number of NULL pointers as well).

proc step*(this: CIntervalManager) {.importcpp: "#->step()".} ## \
## This should be called every frame to do the processing for all the active
## intervals.  It will call step_play() for each interval that has been added
## and that has not yet been removed.
##
## After each call to step(), the scripting language should call
## get_next_event() and get_next_removal() repeatedly to process all the high-
## level (e.g.  Python-interval-based) events and to manage the high-level
## list of intervals.

proc getNextEvent*(this: CIntervalManager): int {.importcpp: "#->get_next_event()".} ## \
## This should be called by the scripting language after each call to step().
## It returns the index number of the next interval that has events requiring
## servicing by the scripting language, or -1 if no more intervals have any
## events pending.
##
## If this function returns something other than -1, it is the scripting
## language's responsibility to query the indicated interval for its next
## event via get_event_index(), and eventually pop_event().
##
## Then get_next_event() should be called again until it returns -1.

proc getNextRemoval*(this: CIntervalManager): int {.importcpp: "#->get_next_removal()".} ## \
## This should be called by the scripting language after each call to step().
## It returns the index number of an interval that was recently removed, or -1
## if no intervals were removed.
##
## If this returns something other than -1, the scripting language should
## clean up its own data structures accordingly, and then call
## get_next_removal() again.

proc output*(this: CIntervalManager, `out`: ostream) {.importcpp: "#->output(#)".}

proc write*(this: CIntervalManager, `out`: ostream) {.importcpp: "#->write(#)".}

proc getGlobalPtr*(_: typedesc[CIntervalManager]): CIntervalManager {.importcpp: "CIntervalManager::get_global_ptr()", header: "cIntervalManager.h".} ## \
## Returns the pointer to the one global CIntervalManager object.

converter getClassType*(_: typedesc[CInterval]): TypeHandle {.importcpp: "CInterval::get_class_type()", header: "cInterval.h".}

proc newCInterval*(param0: CInterval): CInterval {.importcpp: "new CInterval(#)".}

converter getClassType*(_: typedesc[CConstraintInterval]): TypeHandle {.importcpp: "CConstraintInterval::get_class_type()", header: "cConstraintInterval.h".}

proc newCConstraintInterval*(param0: CConstraintInterval): CConstraintInterval {.importcpp: "new CConstraintInterval(#)".}

proc newCConstrainHprInterval*(param0: CConstrainHprInterval): CConstrainHprInterval {.importcpp: "new CConstrainHprInterval(#)".}

proc newCConstrainHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool, hprOffset: LVecBase3): CConstrainHprInterval {.importcpp: "new CConstrainHprInterval(nimStringToStdString(#), #, #, #, #, (LVecBase3 &)(#))", header: stringConversionCode.} ## \
## Constructs a constraint interval that will constrain the orientation of one
## node to the orientation of another, possibly with an added rotation.
##
## If wrt is true, the node's orientation will be transformed into the target
## node's parent's  space before being copied.  If wrt is false, the target
## node's local orientation will be copied unaltered.

proc newCConstrainHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool): CConstrainHprInterval {.importcpp: "new CConstrainHprInterval(nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.} ## \
## Constructs a constraint interval that will constrain the orientation of one
## node to the orientation of another, possibly with an added rotation.
##
## If wrt is true, the node's orientation will be transformed into the target
## node's parent's  space before being copied.  If wrt is false, the target
## node's local orientation will be copied unaltered.

proc getNode*(this: CConstrainHprInterval): NodePath {.importcpp: "#->get_node()".} ## \
## Returns the "source" node.

proc getTarget*(this: CConstrainHprInterval): NodePath {.importcpp: "#->get_target()".} ## \
## Returns the "target" node.

converter getClassType*(_: typedesc[CConstrainHprInterval]): TypeHandle {.importcpp: "CConstrainHprInterval::get_class_type()", header: "cConstrainHprInterval.h".}

proc newCConstrainPosHprInterval*(param0: CConstrainPosHprInterval): CConstrainPosHprInterval {.importcpp: "new CConstrainPosHprInterval(#)".}

proc newCConstrainPosHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool, posOffset: LVecBase3, hprOffset: LVecBase3): CConstrainPosHprInterval {.importcpp: "new CConstrainPosHprInterval(nimStringToStdString(#), #, #, #, #, (LVecBase3 &)(#), (LVecBase3 &)(#))", header: stringConversionCode.} ## \
## Constructs a constraint interval that will constrain the position and
## orientation of one node to the position and orientation of another.
##
## If wrt is true, the node's position and orientation will be transformed
## into the target node's parent's space before being copied.  If wrt is
## false, the target node's local position and orientation will be copied
## unaltered.

proc newCConstrainPosHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool, posOffset: LVecBase3): CConstrainPosHprInterval {.importcpp: "new CConstrainPosHprInterval(nimStringToStdString(#), #, #, #, #, (LVecBase3 &)(#))", header: stringConversionCode.} ## \
## Constructs a constraint interval that will constrain the position and
## orientation of one node to the position and orientation of another.
##
## If wrt is true, the node's position and orientation will be transformed
## into the target node's parent's space before being copied.  If wrt is
## false, the target node's local position and orientation will be copied
## unaltered.

proc newCConstrainPosHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool): CConstrainPosHprInterval {.importcpp: "new CConstrainPosHprInterval(nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.} ## \
## Constructs a constraint interval that will constrain the position and
## orientation of one node to the position and orientation of another.
##
## If wrt is true, the node's position and orientation will be transformed
## into the target node's parent's space before being copied.  If wrt is
## false, the target node's local position and orientation will be copied
## unaltered.

proc getNode*(this: CConstrainPosHprInterval): NodePath {.importcpp: "#->get_node()".} ## \
## Returns the "source" node.

proc getTarget*(this: CConstrainPosHprInterval): NodePath {.importcpp: "#->get_target()".} ## \
## Returns the "target" node.

converter getClassType*(_: typedesc[CConstrainPosHprInterval]): TypeHandle {.importcpp: "CConstrainPosHprInterval::get_class_type()", header: "cConstrainPosHprInterval.h".}

proc newCConstrainPosInterval*(param0: CConstrainPosInterval): CConstrainPosInterval {.importcpp: "new CConstrainPosInterval(#)".}

proc newCConstrainPosInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool, posOffset: LVecBase3): CConstrainPosInterval {.importcpp: "new CConstrainPosInterval(nimStringToStdString(#), #, #, #, #, (LVecBase3 &)(#))", header: stringConversionCode.} ## \
## Constructs a constraint interval that will constrain the position of one
## node to the position of another.
##
## If wrt is true, the node's position will be transformed into the target
## node's parent's  space before being copied.  If wrt is false, the target
## node's local position will be copied unaltered.

proc newCConstrainPosInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool): CConstrainPosInterval {.importcpp: "new CConstrainPosInterval(nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.} ## \
## Constructs a constraint interval that will constrain the position of one
## node to the position of another.
##
## If wrt is true, the node's position will be transformed into the target
## node's parent's  space before being copied.  If wrt is false, the target
## node's local position will be copied unaltered.

proc getNode*(this: CConstrainPosInterval): NodePath {.importcpp: "#->get_node()".} ## \
## Returns the "source" node.

proc getTarget*(this: CConstrainPosInterval): NodePath {.importcpp: "#->get_target()".} ## \
## Returns the "target" node.

converter getClassType*(_: typedesc[CConstrainPosInterval]): TypeHandle {.importcpp: "CConstrainPosInterval::get_class_type()", header: "cConstrainPosInterval.h".}

proc newCConstrainTransformInterval*(param0: CConstrainTransformInterval): CConstrainTransformInterval {.importcpp: "new CConstrainTransformInterval(#)".}

proc newCConstrainTransformInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool): CConstrainTransformInterval {.importcpp: "new CConstrainTransformInterval(nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.} ## \
## Constructs a constraint interval that will constrain the transform of one
## node to the transform of another.  To clarify, the transform of node will
## be copied to target.
##
## If wrt is true, the node's transform will be transformed into the target
## node's parent's  space before being copied.  If wrt is false, the node's
## local transform will be copied unaltered.

proc getNode*(this: CConstrainTransformInterval): NodePath {.importcpp: "#->get_node()".} ## \
## Returns the "source" node.

proc getTarget*(this: CConstrainTransformInterval): NodePath {.importcpp: "#->get_target()".} ## \
## Returns the "target" node.

converter getClassType*(_: typedesc[CConstrainTransformInterval]): TypeHandle {.importcpp: "CConstrainTransformInterval::get_class_type()", header: "cConstrainTransformInterval.h".}

proc getBlendType*(this: CLerpInterval): CLerpInterval_BlendType {.importcpp: "#->get_blend_type()".} ## \
## Returns the blend type specified for the interval.  This controls how the
## linear interpolation behaves near the beginning and end of the lerp period.

proc stringBlendType*(_: typedesc[CLerpInterval], blend_type: string): CLerpInterval_BlendType {.importcpp: "#CLerpInterval::string_blend_type(nimStringToStdString(#))", header: "cLerpInterval.h".} ## \
## Returns the BlendType enumerated value corresponding to the indicated
## string, or BT_invalid if the string doesn't match anything.

converter getClassType*(_: typedesc[CLerpInterval]): TypeHandle {.importcpp: "CLerpInterval::get_class_type()", header: "cLerpInterval.h".}

proc newCLerpInterval*(param0: CLerpInterval): CLerpInterval {.importcpp: "new CLerpInterval(#)".}

proc newCLerpAnimEffectInterval*(param0: CLerpAnimEffectInterval): CLerpAnimEffectInterval {.importcpp: "new CLerpAnimEffectInterval(#)".}

proc newCLerpAnimEffectInterval*(name: string, duration: float64, blend_type: CLerpInterval_BlendType): CLerpAnimEffectInterval {.importcpp: "new CLerpAnimEffectInterval(nimStringToStdString(#), #, #)", header: stringConversionCode.}

proc addControl*(this: CLerpAnimEffectInterval, control: AnimControl, name: string, begin_effect: float32, end_effect: float32) {.importcpp: "#->add_control(#, nimStringToStdString(#), #, #)", header: stringConversionCode.} ## \
## Adds another AnimControl to the list of AnimControls affected by the lerp.
## This control will be lerped from begin_effect to end_effect over the period
## of the lerp.
##
## The AnimControl name parameter is only used when formatting the interval
## for output.

converter getClassType*(_: typedesc[CLerpAnimEffectInterval]): TypeHandle {.importcpp: "CLerpAnimEffectInterval::get_class_type()", header: "cLerpAnimEffectInterval.h".}

proc newCLerpNodePathInterval*(param0: CLerpNodePathInterval): CLerpNodePathInterval {.importcpp: "new CLerpNodePathInterval(#)".}

proc newCLerpNodePathInterval*(name: string, duration: float64, blend_type: CLerpInterval_BlendType, bake_in_start: bool, fluid: bool, node: NodePath, other: NodePath): CLerpNodePathInterval {.importcpp: "new CLerpNodePathInterval(nimStringToStdString(#), #, #, #, #, #, #)", header: stringConversionCode.} ## \
## Constructs a lerp interval that will lerp some properties on the indicated
## node, possibly relative to the indicated other node (if other is nonempty).
##
## You must call set_end_pos(), etc.  for the various properties you wish to
## lerp before the first call to priv_initialize().  If you want to set a
## starting value for any of the properties, you may call set_start_pos(),
## etc.; otherwise, the starting value is taken from the actual node's value
## at the time the lerp is performed.
##
## The starting values may be explicitly specified or omitted.  The value of
## bake_in_start determines the behavior if the starting values are omitted.
## If bake_in_start is true, the values are obtained the first time the lerp
## runs, and thenceforth are stored within the interval.  If bake_in_start is
## false, the starting value is computed each frame, based on assuming the
## current value represents the value set from the last time the interval was
## run.  This "smart" behavior allows code to manipulate the object event
## while it is being lerped, and the lerp continues to apply in a sensible
## way.
##
## If fluid is true, the prev_transform is not adjusted by the lerp;
## otherwise, it is reset.

proc getNode*(this: CLerpNodePathInterval): NodePath {.importcpp: "#->get_node()".} ## \
## Returns the node being lerped.

proc getOther*(this: CLerpNodePathInterval): NodePath {.importcpp: "#->get_other()".} ## \
## Returns the "other" node, which the lerped node is being moved relative to.
## If this is an empty node path, the lerped node is being moved in its own
## coordinate system.

proc setStartPos*(this: CLerpNodePathInterval, pos: LVecBase3) {.importcpp: "#->set_start_pos((LVecBase3 &)(#))".} ## \
## Indicates the initial position of the lerped node.  This is meaningful only
## if set_end_pos() is also called.  This parameter is optional; if
## unspecified, the value will be taken from the node's actual position at the
## time the lerp is performed.

proc setEndPos*(this: CLerpNodePathInterval, pos: LVecBase3) {.importcpp: "#->set_end_pos((LVecBase3 &)(#))".} ## \
## Indicates that the position of the node should be lerped, and specifies the
## final position of the node.  This should be called before
## priv_initialize().  If this is not called, the node's position will not be
## affected by the lerp.

proc setStartHpr*(this: CLerpNodePathInterval, hpr: LVecBase3) {.importcpp: "#->set_start_hpr((LVecBase3 &)(#))".} ## \
## Indicates the initial rotation of the lerped node.  This is meaningful only
## if either set_end_hpr() or set_end_quat() is also called.  This parameter
## is optional; if unspecified, the value will be taken from the node's actual
## rotation at the time the lerp is performed.

proc setEndHpr*(this: CLerpNodePathInterval, quat: LQuaternion) {.importcpp: "#->set_end_hpr(#)".} ## \
## Indicates that the rotation of the node should be lerped, and specifies the
## final rotation of the node.  This should be called before
## priv_initialize().
##
## This special function is overloaded to accept a quaternion, even though the
## function name is set_end_hpr().  The quaternion will be implicitly
## converted to a HPR trio, and the lerp will be performed in HPR space,
## componentwise.

proc setEndHpr*(this: CLerpNodePathInterval, hpr: LVecBase3) {.importcpp: "#->set_end_hpr((LVecBase3 &)(#))".} ## \
## Indicates that the rotation of the node should be lerped, and specifies the
## final rotation of the node.  This should be called before
## priv_initialize().
##
## This replaces a previous call to set_end_quat().  If neither set_end_hpr()
## nor set_end_quat() is called, the node's rotation will not be affected by
## the lerp.

proc setStartQuat*(this: CLerpNodePathInterval, quat: LQuaternion) {.importcpp: "#->set_start_quat(#)".} ## \
## Indicates the initial rotation of the lerped node.  This is meaningful only
## if either set_end_quat() or set_end_hpr() is also called.  This parameter
## is optional; if unspecified, the value will be taken from the node's actual
## rotation at the time the lerp is performed.
##
## The given quaternion needs to be normalized.

proc setEndQuat*(this: CLerpNodePathInterval, quat: LQuaternion) {.importcpp: "#->set_end_quat(#)".} ## \
## Indicates that the rotation of the node should be lerped, and specifies the
## final rotation of the node.  This should be called before
## priv_initialize().
##
## This replaces a previous call to set_end_hpr().  If neither set_end_quat()
## nor set_end_hpr() is called, the node's rotation will not be affected by
## the lerp.
##
## The given quaternion needs to be normalized.

proc setEndQuat*(this: CLerpNodePathInterval, hpr: LVecBase3) {.importcpp: "#->set_end_quat((LVecBase3 &)(#))".} ## \
## Indicates that the rotation of the node should be lerped, and specifies the
## final rotation of the node.  This should be called before
## priv_initialize().
##
## This replaces a previous call to set_end_hpr().  If neither set_end_quat()
## nor set_end_hpr() is called, the node's rotation will not be affected by
## the lerp.
##
## This special function is overloaded to accept a HPR trio, even though the
## function name is set_end_quat().  The HPR will be implicitly converted to a
## quaternion, and the lerp will be performed in quaternion space, as a
## spherical lerp.

proc setStartScale*(this: CLerpNodePathInterval, scale: LVecBase3) {.importcpp: "#->set_start_scale((LVecBase3 &)(#))".} ## \
## Indicates the initial scale of the lerped node.  This is meaningful only if
## set_end_scale() is also called.  This parameter is optional; if
## unspecified, the value will be taken from the node's actual scale at the
## time the lerp is performed.

proc setStartScale*(this: CLerpNodePathInterval, scale: float32) {.importcpp: "#->set_start_scale(#)".} ## \
## Indicates the initial scale of the lerped node.  This is meaningful only if
## set_end_scale() is also called.  This parameter is optional; if
## unspecified, the value will be taken from the node's actual scale at the
## time the lerp is performed.

proc setEndScale*(this: CLerpNodePathInterval, scale: LVecBase3) {.importcpp: "#->set_end_scale((LVecBase3 &)(#))".} ## \
## Indicates that the scale of the node should be lerped, and specifies the
## final scale of the node.  This should be called before priv_initialize().
## If this is not called, the node's scale will not be affected by the lerp.

proc setEndScale*(this: CLerpNodePathInterval, scale: float32) {.importcpp: "#->set_end_scale(#)".} ## \
## Indicates that the scale of the node should be lerped, and specifies the
## final scale of the node.  This should be called before priv_initialize().
## If this is not called, the node's scale will not be affected by the lerp.

proc setStartShear*(this: CLerpNodePathInterval, shear: LVecBase3) {.importcpp: "#->set_start_shear((LVecBase3 &)(#))".} ## \
## Indicates the initial shear of the lerped node.  This is meaningful only if
## set_end_shear() is also called.  This parameter is optional; if
## unspecified, the value will be taken from the node's actual shear at the
## time the lerp is performed.

proc setEndShear*(this: CLerpNodePathInterval, shear: LVecBase3) {.importcpp: "#->set_end_shear((LVecBase3 &)(#))".} ## \
## Indicates that the shear of the node should be lerped, and specifies the
## final shear of the node.  This should be called before priv_initialize().
## If this is not called, the node's shear will not be affected by the lerp.

proc setStartColor*(this: CLerpNodePathInterval, color: LVecBase4) {.importcpp: "#->set_start_color((LVecBase4 &)(#))".} ## \
## Indicates the initial color of the lerped node.  This is meaningful only if
## set_end_color() is also called.  This parameter is optional; if
## unspecified, the value will be taken from the node's actual color at the
## time the lerp is performed.

proc setEndColor*(this: CLerpNodePathInterval, color: LVecBase4) {.importcpp: "#->set_end_color((LVecBase4 &)(#))".} ## \
## Indicates that the color of the node should be lerped, and specifies the
## final color of the node.  This should be called before priv_initialize().
## If this is not called, the node's color will not be affected by the lerp.

proc setStartColorScale*(this: CLerpNodePathInterval, color_scale: LVecBase4) {.importcpp: "#->set_start_color_scale((LVecBase4 &)(#))".} ## \
## Indicates the initial color scale of the lerped node.  This is meaningful
## only if set_end_color_scale() is also called.  This parameter is optional;
## if unspecified, the value will be taken from the node's actual color scale
## at the time the lerp is performed.

proc setEndColorScale*(this: CLerpNodePathInterval, color_scale: LVecBase4) {.importcpp: "#->set_end_color_scale((LVecBase4 &)(#))".} ## \
## Indicates that the color scale of the node should be lerped, and specifies
## the final color scale of the node.  This should be called before
## priv_initialize().  If this is not called, the node's color scale will not
## be affected by the lerp.

proc setTextureStage*(this: CLerpNodePathInterval, stage: TextureStage) {.importcpp: "#->set_texture_stage(#)".} ## \
## Indicates the texture stage that is adjusted by tex_offset, tex_rotate,
## and/or tex_scale.  If this is not set, the default is the default texture
## stage.

proc setStartTexOffset*(this: CLerpNodePathInterval, tex_offset: LVecBase2) {.importcpp: "#->set_start_tex_offset((LVecBase2 &)(#))".} ## \
## Indicates the initial UV offset of the lerped node.  This is meaningful
## only if set_end_tex_offset() is also called.  This parameter is optional;
## if unspecified, the value will be taken from the node's actual UV offset at
## the time the lerp is performed.

proc setEndTexOffset*(this: CLerpNodePathInterval, tex_offset: LVecBase2) {.importcpp: "#->set_end_tex_offset((LVecBase2 &)(#))".} ## \
## Indicates that the UV offset of the node should be lerped, and specifies
## the final UV offset of the node.  This should be called before
## priv_initialize().  If this is not called, the node's UV offset will not be
## affected by the lerp.

proc setStartTexRotate*(this: CLerpNodePathInterval, tex_rotate: float32) {.importcpp: "#->set_start_tex_rotate(#)".} ## \
## Indicates the initial UV rotate of the lerped node.  This is meaningful
## only if set_end_tex_rotate() is also called.  This parameter is optional;
## if unspecified, the value will be taken from the node's actual UV rotate at
## the time the lerp is performed.

proc setEndTexRotate*(this: CLerpNodePathInterval, tex_rotate: float32) {.importcpp: "#->set_end_tex_rotate(#)".} ## \
## Indicates that the UV rotate of the node should be lerped, and specifies
## the final UV rotate of the node.  This should be called before
## priv_initialize().  If this is not called, the node's UV rotate will not be
## affected by the lerp.

proc setStartTexScale*(this: CLerpNodePathInterval, tex_scale: LVecBase2) {.importcpp: "#->set_start_tex_scale((LVecBase2 &)(#))".} ## \
## Indicates the initial UV scale of the lerped node.  This is meaningful only
## if set_end_tex_scale() is also called.  This parameter is optional; if
## unspecified, the value will be taken from the node's actual UV scale at the
## time the lerp is performed.

proc setEndTexScale*(this: CLerpNodePathInterval, tex_scale: LVecBase2) {.importcpp: "#->set_end_tex_scale((LVecBase2 &)(#))".} ## \
## Indicates that the UV scale of the node should be lerped, and specifies the
## final UV scale of the node.  This should be called before
## priv_initialize().  If this is not called, the node's UV scale will not be
## affected by the lerp.

proc setOverride*(this: CLerpNodePathInterval, override: int) {.importcpp: "#->set_override(#)".} ## \
## Changes the override value that will be associated with any state changes
## applied by the lerp.  If this lerp is changing state (for instance, a color
## lerp or a tex matrix lerp), then the new attributes created by this lerp
## will be assigned the indicated override value when they are applied to the
## node.

proc getOverride*(this: CLerpNodePathInterval): int {.importcpp: "#->get_override()".} ## \
## Returns the override value that will be associated with any state changes
## applied by the lerp.  See set_override().

converter getClassType*(_: typedesc[CLerpNodePathInterval]): TypeHandle {.importcpp: "CLerpNodePathInterval::get_class_type()", header: "cLerpNodePathInterval.h".}

proc newCMetaInterval*(param0: CMetaInterval): CMetaInterval {.importcpp: "new CMetaInterval(#)".}

proc newCMetaInterval*(name: string): CMetaInterval {.importcpp: "new CMetaInterval(nimStringToStdString(#))", header: stringConversionCode.}

proc setPrecision*(this: CMetaInterval, precision: float64) {.importcpp: "#->set_precision(#)".} ## \
## Indicates the precision with which time measurements are compared.  For
## numerical accuracy, all floating-point time values are converted to integer
## values internally by scaling by the precision factor.  The larger the
## number given here, the smaller the delta of time that can be
## differentiated; the limit is the maximum integer that can be represented in
## the system.

proc getPrecision*(this: CMetaInterval): float64 {.importcpp: "#->get_precision()".} ## \
## Returns the precision with which time measurements are compared.  See
## set_precision().

proc clearIntervals*(this: CMetaInterval) {.importcpp: "#->clear_intervals()".} ## \
## Resets the list of intervals and prepares for receiving a new list.

proc pushLevel*(this: CMetaInterval, name: string, rel_time: float64, rel_to: CMetaInterval_RelativeStart): int {.importcpp: "#->push_level(nimStringToStdString(#), #, #)", header: stringConversionCode.} ## \
## Marks the beginning of a nested level of child intervals.  Within the
## nested level, a RelativeStart time of RS_level_begin refers to the start of
## the level, and the first interval added within the level is always relative
## to the start of the level.
##
## The return value is the index of the def entry created by this push.

proc addCInterval*(this: CMetaInterval, c_interval: CInterval, rel_time: float64, rel_to: CMetaInterval_RelativeStart): int {.importcpp: "#->add_c_interval(#, #, #)".} ## \
## Adds a new CInterval to the list.  The interval will be played when the
## indicated time (relative to the given point) has been reached.
##
## The return value is the index of the def entry representing the new
## interval.

proc addCInterval*(this: CMetaInterval, c_interval: CInterval, rel_time: float64): int {.importcpp: "#->add_c_interval(#, #)".} ## \
## Adds a new CInterval to the list.  The interval will be played when the
## indicated time (relative to the given point) has been reached.
##
## The return value is the index of the def entry representing the new
## interval.

proc addCInterval*(this: CMetaInterval, c_interval: CInterval): int {.importcpp: "#->add_c_interval(#)".} ## \
## Adds a new CInterval to the list.  The interval will be played when the
## indicated time (relative to the given point) has been reached.
##
## The return value is the index of the def entry representing the new
## interval.

proc addExtIndex*(this: CMetaInterval, ext_index: int, name: string, duration: float64, open_ended: bool, rel_time: float64, rel_to: CMetaInterval_RelativeStart): int {.importcpp: "#->add_ext_index(#, nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.} ## \
## Adds a new external interval to the list.  This represents some object in
## the external scripting language that has properties similar to a CInterval
## (for instance, a Python Interval object).
##
## The CMetaInterval object cannot play this external interval directly, but
## it records a placeholder for it and will ask the scripting language to play
## it when it is time, via is_event_ready() and related methods.
##
## The ext_index number itself is simply a handle that the scripting language
## makes up and associates with its interval object somehow.  The
## CMetaInterval object does not attempt to interpret this value.
##
## The return value is the index of the def entry representing the new
## interval.

proc popLevel*(this: CMetaInterval, duration: float64): int {.importcpp: "#->pop_level(#)".} ## \
## Finishes a level marked by a previous call to push_level(), and returns to
## the previous level.
##
## If the duration is not negative, it represents a phony duration to assign
## to the level, for the purposes of sequencing later intervals.  Otherwise,
## the level's duration is computed based on the intervals within the level.

proc popLevel*(this: CMetaInterval): int {.importcpp: "#->pop_level()".} ## \
## Finishes a level marked by a previous call to push_level(), and returns to
## the previous level.
##
## If the duration is not negative, it represents a phony duration to assign
## to the level, for the purposes of sequencing later intervals.  Otherwise,
## the level's duration is computed based on the intervals within the level.

proc setIntervalStartTime*(this: CMetaInterval, name: string, rel_time: float64, rel_to: CMetaInterval_RelativeStart): bool {.importcpp: "#->set_interval_start_time(nimStringToStdString(#), #, #)", header: stringConversionCode.} ## \
## Adjusts the start time of the child interval with the given name, if found.
## This may be either a C++ interval added via add_c_interval(), or an
## external interval added via add_ext_index(); the name must match exactly.
##
## If the interval is found, its start time is adjusted, and all subsequent
## intervals are adjusting accordingly, and true is returned.  If a matching
## interval is not found, nothing is changed and false is returned.

proc setIntervalStartTime*(this: CMetaInterval, name: string, rel_time: float64): bool {.importcpp: "#->set_interval_start_time(nimStringToStdString(#), #)", header: stringConversionCode.} ## \
## Adjusts the start time of the child interval with the given name, if found.
## This may be either a C++ interval added via add_c_interval(), or an
## external interval added via add_ext_index(); the name must match exactly.
##
## If the interval is found, its start time is adjusted, and all subsequent
## intervals are adjusting accordingly, and true is returned.  If a matching
## interval is not found, nothing is changed and false is returned.

proc getIntervalStartTime*(this: CMetaInterval, name: string): float64 {.importcpp: "#->get_interval_start_time(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the actual start time, relative to the beginning of the interval,
## of the child interval with the given name, if found, or -1 if the interval
## is not found.

proc getIntervalEndTime*(this: CMetaInterval, name: string): float64 {.importcpp: "#->get_interval_end_time(nimStringToStdString(#))", header: stringConversionCode.} ## \
## Returns the actual end time, relative to the beginning of the interval, of
## the child interval with the given name, if found, or -1 if the interval is
## not found.

proc getNumDefs*(this: CMetaInterval): int {.importcpp: "#->get_num_defs()".} ## \
## Returns the number of interval and push/pop definitions that have been
## added to the meta interval.

proc getDefType*(this: CMetaInterval, n: int): CMetaInterval_DefType {.importcpp: "#->get_def_type(#)".} ## \
## Returns the type of the nth interval definition that has been added.

proc getCInterval*(this: CMetaInterval, n: int): CInterval {.importcpp: "#->get_c_interval(#)".} ## \
## Return the CInterval pointer associated with the nth interval definition.
## It is only valid to call this if get_def_type(n) returns DT_c_interval.

proc getExtIndex*(this: CMetaInterval, n: int): int {.importcpp: "#->get_ext_index(#)".} ## \
## Return the external interval index number associated with the nth interval
## definition.  It is only valid to call this if get_def_type(n) returns
## DT_ext_index.

proc isEventReady*(this: CMetaInterval): bool {.importcpp: "#->is_event_ready()".} ## \
## Returns true if a recent call to priv_initialize(), priv_step(), or
## priv_finalize() has left some external intervals ready to play.  If this
## returns true, call get_event_index(), get_event_t(), and pop_event() to
## retrieve the relevant information.

proc getEventIndex*(this: CMetaInterval): int {.importcpp: "#->get_event_index()".} ## \
## If a previous call to is_event_ready() returned true, this returns the
## index number (added via add_event_index()) of the external interval that
## needs to be played.

proc getEventT*(this: CMetaInterval): float64 {.importcpp: "#->get_event_t()".} ## \
## If a previous call to is_event_ready() returned true, this returns the t
## value that should be fed to the given interval.

proc getEventType*(this: CMetaInterval): CInterval_EventType {.importcpp: "#->get_event_type()".} ## \
## If a previous call to is_event_ready() returned true, this returns the type
## of the event (initialize, step, finalize, etc.) for the given interval.

proc popEvent*(this: CMetaInterval) {.importcpp: "#->pop_event()".} ## \
## Acknowledges that the external interval on the top of the queue has been
## extracted, and is about to be serviced by the scripting language.  This
## prepares the interval so the next call to is_event_ready() will return
## information about the next external interval on the queue, if any.

proc timeline*(this: CMetaInterval, `out`: ostream) {.importcpp: "#->timeline(#)".} ## \
## Outputs a list of all events in the order in which they occur.

converter getClassType*(_: typedesc[CMetaInterval]): TypeHandle {.importcpp: "CMetaInterval::get_class_type()", header: "cMetaInterval.h".}

proc newHideInterval*(param0: HideInterval): HideInterval {.importcpp: "new HideInterval(#)".}

proc newHideInterval*(node: NodePath, name: string): HideInterval {.importcpp: "new HideInterval(#, nimStringToStdString(#))", header: stringConversionCode.}

proc newHideInterval*(node: NodePath): HideInterval {.importcpp: "new HideInterval(#)".}

converter getClassType*(_: typedesc[HideInterval]): TypeHandle {.importcpp: "HideInterval::get_class_type()", header: "hideInterval.h".}

converter getClassType*(_: typedesc[LerpBlendType]): TypeHandle {.importcpp: "LerpBlendType::get_class_type()", header: "lerpblend.h".} ## \
## now for typehandle stuff

proc newEaseInBlendType*(): EaseInBlendType {.importcpp: "new EaseInBlendType()".}

converter getClassType*(_: typedesc[EaseInBlendType]): TypeHandle {.importcpp: "EaseInBlendType::get_class_type()", header: "lerpblend.h".} ## \
## now for typehandle stuff

proc newEaseOutBlendType*(): EaseOutBlendType {.importcpp: "new EaseOutBlendType()".}

converter getClassType*(_: typedesc[EaseOutBlendType]): TypeHandle {.importcpp: "EaseOutBlendType::get_class_type()", header: "lerpblend.h".} ## \
## now for typehandle stuff

proc newEaseInOutBlendType*(): EaseInOutBlendType {.importcpp: "new EaseInOutBlendType()".}

converter getClassType*(_: typedesc[EaseInOutBlendType]): TypeHandle {.importcpp: "EaseInOutBlendType::get_class_type()", header: "lerpblend.h".} ## \
## now for typehandle stuff

proc newNoBlendType*(): NoBlendType {.importcpp: "new NoBlendType()".}

converter getClassType*(_: typedesc[NoBlendType]): TypeHandle {.importcpp: "NoBlendType::get_class_type()", header: "lerpblend.h".} ## \
## now for typehandle stuff

proc newShowInterval*(node: NodePath, name: string): ShowInterval {.importcpp: "new ShowInterval(#, nimStringToStdString(#))", header: stringConversionCode.}

proc newShowInterval*(node: NodePath): ShowInterval {.importcpp: "new ShowInterval(#)".}

proc newShowInterval*(param0: ShowInterval): ShowInterval {.importcpp: "new ShowInterval(#)".}

converter getClassType*(_: typedesc[ShowInterval]): TypeHandle {.importcpp: "ShowInterval::get_class_type()", header: "showInterval.h".}

proc newWaitInterval*(param0: WaitInterval): WaitInterval {.importcpp: "new WaitInterval(#)".}

proc newWaitInterval*(duration: float64): WaitInterval {.importcpp: "new WaitInterval(#)".} ## \
## All Wait intervals have the same name.  No one really cares if their names
## are unique, after all.

converter getClassType*(_: typedesc[WaitInterval]): TypeHandle {.importcpp: "WaitInterval::get_class_type()", header: "waitInterval.h".}

proc initCConnectionRepository*(has_owner_view: bool, threaded_net: bool): CConnectionRepository {.importcpp: "CConnectionRepository(#, #)".}

proc initCConnectionRepository*(has_owner_view: bool): CConnectionRepository {.importcpp: "CConnectionRepository(#)".}

proc initCConnectionRepository*(): CConnectionRepository {.importcpp: "CConnectionRepository()".}

proc getDcFile*(this: CConnectionRepository): DCFile {.importcpp: "#.get_dc_file()".} ## \
## Returns the DCFile object associated with this repository.

proc hasOwnerView*(this: CConnectionRepository): bool {.importcpp: "#.has_owner_view()".} ## \
## Returns true if this repository can have 'owner' views of distributed
## objects.

proc setHandleCUpdates*(this: CConnectionRepository, handle_c_updates: bool) {.importcpp: "#.set_handle_c_updates(#)".} ## \
## Set true to specify this repository should process distributed updates
## internally in C++ code, or false if it should return them to Python.

proc getHandleCUpdates*(this: CConnectionRepository): bool {.importcpp: "#.get_handle_c_updates()".} ## \
## Returns true if this repository will process distributed updates internally
## in C++ code, or false if it will return them to Python.

proc setClientDatagram*(this: CConnectionRepository, client_datagram: bool) {.importcpp: "#.set_client_datagram(#)".} ## \
## Sets the client_datagram flag.  If this is true, incoming datagrams are not
## expected to be prefixed with the server routing information like message
## sender, channel number, etc.; otherwise, these server fields are parsed and
## removed from each incoming datagram.

proc getClientDatagram*(this: CConnectionRepository): bool {.importcpp: "#.get_client_datagram()".} ## \
## Returns the client_datagram flag.

proc setHandleDatagramsInternally*(this: CConnectionRepository, handle_datagrams_internally: bool) {.importcpp: "#.set_handle_datagrams_internally(#)".} ## \
## Sets the handle_datagrams_internally flag.  When true, certain message
## types can be handled by the C++ code in in this module.  When false, all
## datagrams, regardless of message type, are passed up to Python for
## processing.
##
## The CMU distributed-object implementation requires this to be set false.

proc getHandleDatagramsInternally*(this: CConnectionRepository): bool {.importcpp: "#.get_handle_datagrams_internally()".} ## \
## Returns the handle_datagrams_internally flag.

proc setTcpHeaderSize*(this: CConnectionRepository, tcp_header_size: int) {.importcpp: "#.set_tcp_header_size(#)".} ## \
## Sets the header size of TCP packets.  At the present, legal values for this
## are 0, 2, or 4; this specifies the number of bytes to use encode the
## datagram length at the start of each TCP datagram.  Sender and receiver
## must independently agree on this.

proc getTcpHeaderSize*(this: CConnectionRepository): int {.importcpp: "#.get_tcp_header_size()".} ## \
## Returns the current setting of TCP header size.  See set_tcp_header_size().

proc setConnectionHttp*(this: CConnectionRepository, channel: HTTPChannel) {.importcpp: "#.set_connection_http(#)".} ## \
## Once a connection has been established via the HTTP interface, gets the
## connection and uses it.  The supplied HTTPChannel object must have a
## connection available via get_connection().

proc getStream*(this: CConnectionRepository): SocketStream {.importcpp: "#.get_stream()".} ## \
## Returns the SocketStream that internally represents the already-established
## HTTP connection.  Returns NULL if there is no current HTTP connection.

proc tryConnectNet*(this: CConnectionRepository, url: URLSpec): bool {.importcpp: "#.try_connect_net(#)".} ## \
## Uses Panda's "net" library to try to connect to the server and port named
## in the indicated URL.  Returns true if successful, false otherwise.

proc getQcm*(this: CConnectionRepository): QueuedConnectionManager {.importcpp: "#.get_qcm()".} ## \
## Returns the QueuedConnectionManager object associated with the repository.

proc getCw*(this: CConnectionRepository): ConnectionWriter {.importcpp: "#.get_cw()".} ## \
## Returns the ConnectionWriter object associated with the repository.

proc getQcr*(this: CConnectionRepository): QueuedConnectionReader {.importcpp: "#.get_qcr()".} ## \
## Returns the QueuedConnectionReader object associated with the repository.

proc connectNative*(this: CConnectionRepository, url: URLSpec): bool {.importcpp: "#.connect_native(#)".} ## \
## Connects to the server using Panda's low-level and fast "native net"
## library.

proc getBdc*(this: CConnectionRepository): Buffered_DatagramConnection {.importcpp: "#.get_bdc()".} ## \
## Returns the Buffered_DatagramConnection object associated with the
## repository.

proc checkDatagram*(this: CConnectionRepository): bool {.importcpp: "#.check_datagram()".} ## \
## Returns true if a new datagram is available, false otherwise.  If the
## return value is true, the new datagram may be retrieved via get_datagram(),
## or preferably, with get_datagram_iterator() and get_msg_type().

proc getDatagram*(this: CConnectionRepository, dg: Datagram) {.importcpp: "#.get_datagram(#)".} ## \
## Fills the datagram object with the datagram most recently retrieved by
## check_datagram().

proc getDatagramIterator*(this: CConnectionRepository, di: DatagramIterator) {.importcpp: "#.get_datagram_iterator(#)".} ## \
## Fills the DatagramIterator object with the iterator for the datagram most
## recently retrieved by check_datagram().  This iterator has already read
## past the datagram header and the message type, and is positioned at the
## beginning of data.

proc getMsgChannel*(this: CConnectionRepository, offset: int): clonglong {.importcpp: "#.get_msg_channel(#)".} ## \
## Returns the channel(s) to which the current message was sent, according to
## the datagram headers.  This information is not available to the client.

proc getMsgChannel*(this: CConnectionRepository): clonglong {.importcpp: "#.get_msg_channel()".} ## \
## Returns the channel(s) to which the current message was sent, according to
## the datagram headers.  This information is not available to the client.

proc getMsgChannelCount*(this: CConnectionRepository): int {.importcpp: "#.get_msg_channel_count()".}

proc getMsgSender*(this: CConnectionRepository): clonglong {.importcpp: "#.get_msg_sender()".} ## \
## Returns the sender ID of the current message, according to the datagram
## headers.  This information is not available to the client.

proc getMsgType*(this: CConnectionRepository): int {.importcpp: "#.get_msg_type()".} ## \
## Returns the type ID of the current message, according to the datagram
## headers.

proc getOverflowEventName*(_: typedesc[CConnectionRepository]): string {.importcpp: "nimStringFromStdString(CConnectionRepository::get_overflow_event_name())", header: "cConnectionRepository.h".} ## \
## Returns event string that will be thrown if the datagram reader queue
## overflows.

proc isConnected*(this: CConnectionRepository): bool {.importcpp: "#.is_connected()".} ## \
## Returns true if the connection to the gameserver is established and still
## good, false if we are not connected.  A false value means either (a) we
## never successfully connected, (b) we explicitly called disconnect(), or (c)
## we were connected, but the connection was spontaneously lost.

proc sendDatagram*(this: CConnectionRepository, dg: Datagram): bool {.importcpp: "#.send_datagram(#)".} ## \
## Queues the indicated datagram for sending to the server.  It may not get
## sent immediately if collect_tcp is in effect; call flush() to guarantee it
## is sent now.

proc setWantMessageBundling*(this: CConnectionRepository, flag: bool) {.importcpp: "#.set_want_message_bundling(#)".} ## \
## Enable/disable outbound message bundling

proc getWantMessageBundling*(this: CConnectionRepository): bool {.importcpp: "#.get_want_message_bundling()".} ## \
## Returns true if message bundling enabled

proc setInQuietZone*(this: CConnectionRepository, flag: bool) {.importcpp: "#.set_in_quiet_zone(#)".} ## \
## Enables/disables quiet zone mode

proc getInQuietZone*(this: CConnectionRepository): bool {.importcpp: "#.get_in_quiet_zone()".} ## \
## Returns true if repository is in quiet zone mode

proc startMessageBundle*(this: CConnectionRepository) {.importcpp: "#.start_message_bundle()".} ## \
## Send a set of messages to the state server that will be processed
## atomically.  For instance, you can do a combined setLocation/setPos and
## prevent race conditions where clients briefly get the setLocation but not
## the setPos, because the state server hasn't processed the setPos yet

proc isBundlingMessages*(this: CConnectionRepository): bool {.importcpp: "#.is_bundling_messages()".} ## \
## Returns true if repository is queueing outgoing messages into a message
## bundle

proc sendMessageBundle*(this: CConnectionRepository, channel: int, sender_channel: int) {.importcpp: "#.send_message_bundle(#, #)".} ## \
## Send network messages queued up since startMessageBundle was called.

proc abandonMessageBundles*(this: CConnectionRepository) {.importcpp: "#.abandon_message_bundles()".} ## \
## throw out any msgs that have been queued up for message bundles

proc bundleMsg*(this: CConnectionRepository, dg: Datagram) {.importcpp: "#.bundle_msg(#)".}

proc considerFlush*(this: CConnectionRepository): bool {.importcpp: "#.consider_flush()".} ## \
## Sends the most recently queued data if enough time has elapsed.  This only
## has meaning if set_collect_tcp() has been set to true.

proc flush*(this: CConnectionRepository): bool {.importcpp: "#.flush()".} ## \
## Sends the most recently queued data now.  This only has meaning if
## set_collect_tcp() has been set to true.

proc disconnect*(this: CConnectionRepository) {.importcpp: "#.disconnect()".} ## \
## Closes the connection to the server.

proc shutdown*(this: CConnectionRepository) {.importcpp: "#.shutdown()".} ## \
## May be called at application shutdown to ensure all threads are cleaned up.

proc setSimulatedDisconnect*(this: CConnectionRepository, simulated_disconnect: bool) {.importcpp: "#.set_simulated_disconnect(#)".} ## \
## Sets the simulated disconnect flag.  While this is true, no datagrams will
## be retrieved from or sent to the server.  The idea is to simulate a
## temporary network outage.

proc getSimulatedDisconnect*(this: CConnectionRepository): bool {.importcpp: "#.get_simulated_disconnect()".} ## \
## Returns the simulated disconnect flag.  While this is true, no datagrams
## will be retrieved from or sent to the server.  The idea is to simulate a
## temporary network outage.

proc toggleVerbose*(this: CConnectionRepository) {.importcpp: "#.toggle_verbose()".} ## \
## Toggles the current setting of the verbose flag.  When true, this describes
## every message going back and forth on the wire.

proc setVerbose*(this: CConnectionRepository, verbose: bool) {.importcpp: "#.set_verbose(#)".} ## \
## Directly sets the verbose flag.  When true, this describes every message
## going back and forth on the wire.

proc getVerbose*(this: CConnectionRepository): bool {.importcpp: "#.get_verbose()".} ## \
## Returns the current setting of the verbose flag.  When true, this describes
## every message going back and forth on the wire.

proc setTimeWarning*(this: CConnectionRepository, time_warning: float32) {.importcpp: "#.set_time_warning(#)".} ## \
## Directly sets the time_warning field.  When non zero, this describes every
## message going back and forth on the wire when the msg handling time is over
## it

proc getTimeWarning*(this: CConnectionRepository): float32 {.importcpp: "#.get_time_warning()".} ## \
## Returns the current setting of the time_warning field.

proc initCDistributedSmoothNodeBase*(): CDistributedSmoothNodeBase {.importcpp: "CDistributedSmoothNodeBase()".}

proc initCDistributedSmoothNodeBase*(param0: CDistributedSmoothNodeBase): CDistributedSmoothNodeBase {.importcpp: "CDistributedSmoothNodeBase(#)".}

proc setRepository*(this: CDistributedSmoothNodeBase, repository: CConnectionRepository, is_ai: bool, ai_id: clonglong) {.importcpp: "#.set_repository(#, #, #)".} ## \
## Tells the C++ instance definition about the AI or Client repository, used
## for sending datagrams.

proc initialize*(this: CDistributedSmoothNodeBase, node_path: NodePath, dclass: DCClass, do_id: clonglong) {.importcpp: "#.initialize(#, #, #)".} ## \
## Initializes the internal structures from some constructs that are normally
## stored only in Python.  Also reads the current node's pos & hpr values in
## preparation for transmitting them via one of the broadcast_pos_hpr_\*()
## methods.

proc sendEverything*(this: CDistributedSmoothNodeBase) {.importcpp: "#.send_everything()".} ## \
## Broadcasts the current pos/hpr in its complete form.

proc broadcastPosHprFull*(this: CDistributedSmoothNodeBase) {.importcpp: "#.broadcast_pos_hpr_full()".} ## \
## Examines the complete pos/hpr information to see which of the six elements
## have changed, and broadcasts the appropriate messages.

proc broadcastPosHprXyh*(this: CDistributedSmoothNodeBase) {.importcpp: "#.broadcast_pos_hpr_xyh()".} ## \
## Examines only X, Y, and H of the pos/hpr information, and broadcasts the
## appropriate messages.

proc broadcastPosHprXy*(this: CDistributedSmoothNodeBase) {.importcpp: "#.broadcast_pos_hpr_xy()".} ## \
## Examines only X and Y of the pos/hpr information, and broadcasts the
## appropriate messages.

proc setCurrL*(this: CDistributedSmoothNodeBase, l: clonglong) {.importcpp: "#.set_curr_l(#)".} ## \
## Appends the timestamp and sends the update.

proc printCurrL*(this: CDistributedSmoothNodeBase) {.importcpp: "#.print_curr_l()".}

proc newCMotionTrail*(): CMotionTrail {.importcpp: "new CMotionTrail()".} ## \
## Constructor

proc newCMotionTrail*(param0: CMotionTrail): CMotionTrail {.importcpp: "new CMotionTrail(#)".}

proc reset*(this: CMotionTrail) {.importcpp: "#->reset()".} ## \
## Reset the frame sample history.

proc resetVertexList*(this: CMotionTrail) {.importcpp: "#->reset_vertex_list()".} ## \
## Reset the vertex list.

proc enable*(this: CMotionTrail, enable: bool) {.importcpp: "#->enable(#)".} ## \
## Enable/disable the motion trail.

proc setGeomNode*(this: CMotionTrail, geom_node: GeomNode) {.importcpp: "#->set_geom_node(#)".} ## \
## Set the GeomNode.

proc addVertex*(this: CMotionTrail, vertex: LVector4, start_color: LVector4, end_color: LVector4, v: float32) {.importcpp: "#->add_vertex((LVector4 &)(#), (LVector4 &)(#), (LVector4 &)(#), #)".} ## \
## Add a vertex.

proc setParameters*(this: CMotionTrail, sampling_time: float32, time_window: float32, use_texture: bool, calculate_relative_matrix: bool, use_nurbs: bool, resolution_distance: float32) {.importcpp: "#->set_parameters(#, #, #, #, #, #)".} ## \
## Set motion trail parameters.
##
## sampling_time = Can be used to specify a lower sampling rate than the frame
## rate.  Use 0.0 with nurbs.
##
## time_window = a component for the "length" of the motion trail.  The motion
## trail length = time_window \* velocity of the object.
##
## use_texture = texture option on/off.
##
## calculate_relative_matrix = calculate relative matrix on/off.
##
## use_nurbs = nurbs option on/off
##
## resolution_distance = the distance used to determine the number of geometry
## samples.  samples = motion trail length / resolution_distance.  Applicable
## only if nurbs is on.

proc checkForUpdate*(this: CMotionTrail, current_time: float32): int {.importcpp: "#->check_for_update(#)".} ## \
## Check if a sample can be submitted.

proc updateMotionTrail*(this: CMotionTrail, current_time: float32, transform: LMatrix4) {.importcpp: "#->update_motion_trail(#, #)".} ## \
## See class header comments.

converter getClassType*(_: typedesc[CMotionTrail]): TypeHandle {.importcpp: "CMotionTrail::get_class_type()", header: "cMotionTrail.h".}

func `$`*(this: DCField): string =
  var str : StringStream
  this.output(str)
  str.data

func `$`*(this: DCDeclaration): string =
  var str : StringStream
  this.output(str)
  str.data

func `$`*(this: DCClass): string =
  var str : StringStream
  this.output(str)
  str.data

func `$`*(this: SmoothMover): string =
  var str : StringStream
  this.output(str)
  str.data

func `$`*(this: CInterval): string =
  var str : StringStream
  this.output(str)
  str.data

func `$`*(this: CIntervalManager): string =
  var str : StringStream
  this.output(str)
  str.data

