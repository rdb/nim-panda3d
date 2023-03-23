
import ./private
import ./core

when defined(vcc):
  when defined(pandaDir):
    {.passL: "\"" & pandaDir & "/lib/libp3direct.lib\"".}
  else:
    {.passL: "libp3direct.lib".}
else:
  {.passL: "-lp3direct".}

type DCSubatomicType* {.importcpp: "DCSubatomicType", header: "dcSubatomicType.h".} = enum
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

type DCPackerInterface* {.importcpp: "DCPackerInterface*", bycopy, pure, inheritable, header: "dcPackerInterface.h".} = object

converter toDCPackerInterface*(_: type(nil)): DCPackerInterface {.importcpp: "(nullptr)".}

type DCKeywordList* {.importcpp: "DCKeywordList", pure, inheritable, header: "dcKeywordList.h".} = object

type DCField* {.importcpp: "DCField*", bycopy, pure, inheritable, header: "dcField.h".} = object of DCPackerInterface

converter upcastToDCKeywordList*(_: typedesc[DCField]): typedesc[DCKeywordList] = typedesc[DCKeywordList]

converter toDCField*(_: type(nil)): DCField {.importcpp: "(nullptr)".}

type DCPackData* {.importcpp: "DCPackData", pure, inheritable, header: "dcPackData.h".} = object

type DCPacker* {.importcpp: "DCPacker", pure, inheritable, header: "dcPacker.h".} = object

type DCParameter* {.importcpp: "DCParameter*", bycopy, pure, inheritable, header: "dcParameter.h".} = object of DCField

converter toDCParameter*(_: type(nil)): DCParameter {.importcpp: "(nullptr)".}

type DCArrayParameter* {.importcpp: "DCArrayParameter*", bycopy, pure, inheritable, header: "dcArrayParameter.h".} = object of DCParameter

converter toDCArrayParameter*(_: type(nil)): DCArrayParameter {.importcpp: "(nullptr)".}

type DCAtomicField* {.importcpp: "DCAtomicField*", bycopy, pure, inheritable, header: "dcAtomicField.h".} = object of DCField

converter toDCAtomicField*(_: type(nil)): DCAtomicField {.importcpp: "(nullptr)".}

type DCDeclaration* {.importcpp: "DCDeclaration*", bycopy, pure, inheritable, header: "dcDeclaration.h".} = object

converter toDCDeclaration*(_: type(nil)): DCDeclaration {.importcpp: "(nullptr)".}

type DCClass* {.importcpp: "DCClass*", bycopy, pure, inheritable, header: "dcClass.h".} = object of DCDeclaration

converter toDCClass*(_: type(nil)): DCClass {.importcpp: "(nullptr)".}

type DCClassParameter* {.importcpp: "DCClassParameter", pure, inheritable, header: "dcClassParameter.h".} = object of DCParameter

type DCFile* {.importcpp: "DCFile", pure, inheritable, header: "dcFile.h".} = object

type DCKeyword* {.importcpp: "DCKeyword*", bycopy, pure, inheritable, header: "dcKeyword.h".} = object of DCDeclaration

converter toDCKeyword*(_: type(nil)): DCKeyword {.importcpp: "(nullptr)".}

type DCMolecularField* {.importcpp: "DCMolecularField", pure, inheritable, header: "dcMolecularField.h".} = object of DCField

type DCSimpleParameter* {.importcpp: "DCSimpleParameter", pure, inheritable, header: "dcSimpleParameter.h".} = object of DCParameter

type DCSwitch* {.importcpp: "DCSwitch*", bycopy, pure, inheritable, header: "dcSwitch.h".} = object of DCDeclaration

converter toDCSwitch*(_: type(nil)): DCSwitch {.importcpp: "(nullptr)".}

type DCSwitchParameter* {.importcpp: "DCSwitchParameter", pure, inheritable, header: "dcSwitchParameter.h".} = object of DCParameter

type DCTypedef* {.importcpp: "DCTypedef*", bycopy, pure, inheritable, header: "dcTypedef.h".} = object of DCDeclaration

converter toDCTypedef*(_: type(nil)): DCTypedef {.importcpp: "(nullptr)".}

type SmoothMover* {.importcpp: "SmoothMover", pure, inheritable, header: "smoothMover.h".} = object

type SmoothMover_SmoothMode {.importcpp: "SmoothMover::SmoothMode", pure, header: "smoothMover.h".} = enum
  SM_off = 0
  SM_on = 1

template SmoothMode*(_: typedesc[SmoothMover]): typedesc[SmoothMover_SmoothMode] = typedesc[SmoothMover_SmoothMode]
template SmoothMode*(_: typedesc[SmoothMover], value: untyped): SmoothMover_SmoothMode = SmoothMover_SmoothMode(value)

template SM_off*(_: typedesc[SmoothMover]): SmoothMover_SmoothMode = SmoothMover_SmoothMode.SM_off
template SM_on*(_: typedesc[SmoothMover]): SmoothMover_SmoothMode = SmoothMover_SmoothMode.SM_on

type SmoothMover_PredictionMode {.importcpp: "SmoothMover::PredictionMode", pure, header: "smoothMover.h".} = enum
  PM_off = 0
  PM_on = 1

template PredictionMode*(_: typedesc[SmoothMover]): typedesc[SmoothMover_PredictionMode] = typedesc[SmoothMover_PredictionMode]
template PredictionMode*(_: typedesc[SmoothMover], value: untyped): SmoothMover_PredictionMode = SmoothMover_PredictionMode(value)

template PM_off*(_: typedesc[SmoothMover]): SmoothMover_PredictionMode = SmoothMover_PredictionMode.PM_off
template PM_on*(_: typedesc[SmoothMover]): SmoothMover_PredictionMode = SmoothMover_PredictionMode.PM_on

type CInterval* {.importcpp: "PT(CInterval)", bycopy, pure, inheritable, header: "cInterval.h".} = object of TypedReferenceCount

converter toCInterval*(_: type(nil)): CInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CInterval], obj: TypedObject): CInterval {.importcpp: "DCAST(CInterval, @)".}

type CInterval_EventType {.importcpp: "CInterval::EventType", pure, header: "cInterval.h".} = enum
  ET_initialize = 0
  ET_instant = 1
  ET_step = 2
  ET_finalize = 3
  ET_reverseInitialize = 4
  ET_reverseInstant = 5
  ET_reverseFinalize = 6
  ET_interrupt = 7

template EventType*(_: typedesc[CInterval]): typedesc[CInterval_EventType] = typedesc[CInterval_EventType]
template EventType*(_: typedesc[CInterval], value: untyped): CInterval_EventType = CInterval_EventType(value)

template ET_initialize*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_initialize
template ET_instant*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_instant
template ET_step*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_step
template ET_finalize*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_finalize
template ET_reverseInitialize*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_reverseInitialize
template ET_reverseInstant*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_reverseInstant
template ET_reverseFinalize*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_reverseFinalize
template ET_interrupt*(_: typedesc[CInterval]): CInterval_EventType = CInterval_EventType.ET_interrupt

type CInterval_State {.importcpp: "CInterval::State", pure, header: "cInterval.h".} = enum
  S_initial = 0
  S_started = 1
  S_paused = 2
  S_final = 3

template State*(_: typedesc[CInterval]): typedesc[CInterval_State] = typedesc[CInterval_State]
template State*(_: typedesc[CInterval], value: untyped): CInterval_State = CInterval_State(value)

template S_initial*(_: typedesc[CInterval]): CInterval_State = CInterval_State.S_initial
template S_started*(_: typedesc[CInterval]): CInterval_State = CInterval_State.S_started
template S_paused*(_: typedesc[CInterval]): CInterval_State = CInterval_State.S_paused
template S_final*(_: typedesc[CInterval]): CInterval_State = CInterval_State.S_final

type CIntervalManager* {.importcpp: "CIntervalManager*", bycopy, pure, inheritable, header: "cIntervalManager.h".} = object

converter toCIntervalManager*(_: type(nil)): CIntervalManager {.importcpp: "(nullptr)".}

type CConstraintInterval* {.importcpp: "PT(CConstraintInterval)", bycopy, pure, inheritable, header: "cConstraintInterval.h".} = object of CInterval

converter toCConstraintInterval*(_: type(nil)): CConstraintInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CConstraintInterval], obj: TypedObject): CConstraintInterval {.importcpp: "DCAST(CConstraintInterval, @)".}

type CConstrainHprInterval* {.importcpp: "PT(CConstrainHprInterval)", bycopy, pure, inheritable, header: "cConstrainHprInterval.h".} = object of CConstraintInterval

converter toCConstrainHprInterval*(_: type(nil)): CConstrainHprInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CConstrainHprInterval], obj: TypedObject): CConstrainHprInterval {.importcpp: "DCAST(CConstrainHprInterval, @)".}

type CConstrainPosHprInterval* {.importcpp: "PT(CConstrainPosHprInterval)", bycopy, pure, inheritable, header: "cConstrainPosHprInterval.h".} = object of CConstraintInterval

converter toCConstrainPosHprInterval*(_: type(nil)): CConstrainPosHprInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CConstrainPosHprInterval], obj: TypedObject): CConstrainPosHprInterval {.importcpp: "DCAST(CConstrainPosHprInterval, @)".}

type CConstrainPosInterval* {.importcpp: "PT(CConstrainPosInterval)", bycopy, pure, inheritable, header: "cConstrainPosInterval.h".} = object of CConstraintInterval

converter toCConstrainPosInterval*(_: type(nil)): CConstrainPosInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CConstrainPosInterval], obj: TypedObject): CConstrainPosInterval {.importcpp: "DCAST(CConstrainPosInterval, @)".}

type CConstrainTransformInterval* {.importcpp: "PT(CConstrainTransformInterval)", bycopy, pure, inheritable, header: "cConstrainTransformInterval.h".} = object of CConstraintInterval

converter toCConstrainTransformInterval*(_: type(nil)): CConstrainTransformInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CConstrainTransformInterval], obj: TypedObject): CConstrainTransformInterval {.importcpp: "DCAST(CConstrainTransformInterval, @)".}

type CLerpInterval* {.importcpp: "PT(CLerpInterval)", bycopy, pure, inheritable, header: "cLerpInterval.h".} = object of CInterval

converter toCLerpInterval*(_: type(nil)): CLerpInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CLerpInterval], obj: TypedObject): CLerpInterval {.importcpp: "DCAST(CLerpInterval, @)".}

type CLerpInterval_BlendType {.importcpp: "CLerpInterval::BlendType", pure, header: "cLerpInterval.h".} = enum
  BT_noBlend = 0
  BT_easeIn = 1
  BT_easeOut = 2
  BT_easeInOut = 3
  BT_invalid = 4

template BlendType*(_: typedesc[CLerpInterval]): typedesc[CLerpInterval_BlendType] = typedesc[CLerpInterval_BlendType]
template BlendType*(_: typedesc[CLerpInterval], value: untyped): CLerpInterval_BlendType = CLerpInterval_BlendType(value)

template BT_noBlend*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_noBlend
template BT_easeIn*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_easeIn
template BT_easeOut*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_easeOut
template BT_easeInOut*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_easeInOut
template BT_invalid*(_: typedesc[CLerpInterval]): CLerpInterval_BlendType = CLerpInterval_BlendType.BT_invalid

type CLerpAnimEffectInterval* {.importcpp: "PT(CLerpAnimEffectInterval)", bycopy, pure, inheritable, header: "cLerpAnimEffectInterval.h".} = object of CLerpInterval

converter toCLerpAnimEffectInterval*(_: type(nil)): CLerpAnimEffectInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CLerpAnimEffectInterval], obj: TypedObject): CLerpAnimEffectInterval {.importcpp: "DCAST(CLerpAnimEffectInterval, @)".}

type CLerpNodePathInterval* {.importcpp: "PT(CLerpNodePathInterval)", bycopy, pure, inheritable, header: "cLerpNodePathInterval.h".} = object of CLerpInterval

converter toCLerpNodePathInterval*(_: type(nil)): CLerpNodePathInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CLerpNodePathInterval], obj: TypedObject): CLerpNodePathInterval {.importcpp: "DCAST(CLerpNodePathInterval, @)".}

type CMetaInterval* {.importcpp: "PT(CMetaInterval)", bycopy, pure, inheritable, header: "cMetaInterval.h".} = object of CInterval

converter toCMetaInterval*(_: type(nil)): CMetaInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CMetaInterval], obj: TypedObject): CMetaInterval {.importcpp: "DCAST(CMetaInterval, @)".}

type CMetaInterval_RelativeStart {.importcpp: "CMetaInterval::RelativeStart", pure, header: "cMetaInterval.h".} = enum
  RS_previousEnd = 0
  RS_previousBegin = 1
  RS_levelBegin = 2

template RelativeStart*(_: typedesc[CMetaInterval]): typedesc[CMetaInterval_RelativeStart] = typedesc[CMetaInterval_RelativeStart]
template RelativeStart*(_: typedesc[CMetaInterval], value: untyped): CMetaInterval_RelativeStart = CMetaInterval_RelativeStart(value)

template RS_previousEnd*(_: typedesc[CMetaInterval]): CMetaInterval_RelativeStart = CMetaInterval_RelativeStart.RS_previousEnd
template RS_previousBegin*(_: typedesc[CMetaInterval]): CMetaInterval_RelativeStart = CMetaInterval_RelativeStart.RS_previousBegin
template RS_levelBegin*(_: typedesc[CMetaInterval]): CMetaInterval_RelativeStart = CMetaInterval_RelativeStart.RS_levelBegin

type CMetaInterval_DefType {.importcpp: "CMetaInterval::DefType", pure, header: "cMetaInterval.h".} = enum
  DT_cInterval = 0
  DT_extIndex = 1
  DT_pushLevel = 2
  DT_popLevel = 3

template DefType*(_: typedesc[CMetaInterval]): typedesc[CMetaInterval_DefType] = typedesc[CMetaInterval_DefType]
template DefType*(_: typedesc[CMetaInterval], value: untyped): CMetaInterval_DefType = CMetaInterval_DefType(value)

template DT_cInterval*(_: typedesc[CMetaInterval]): CMetaInterval_DefType = CMetaInterval_DefType.DT_cInterval
template DT_extIndex*(_: typedesc[CMetaInterval]): CMetaInterval_DefType = CMetaInterval_DefType.DT_extIndex
template DT_pushLevel*(_: typedesc[CMetaInterval]): CMetaInterval_DefType = CMetaInterval_DefType.DT_pushLevel
template DT_popLevel*(_: typedesc[CMetaInterval]): CMetaInterval_DefType = CMetaInterval_DefType.DT_popLevel

type HideInterval* {.importcpp: "PT(HideInterval)", bycopy, pure, inheritable, header: "hideInterval.h".} = object of CInterval

converter toHideInterval*(_: type(nil)): HideInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[HideInterval], obj: TypedObject): HideInterval {.importcpp: "DCAST(HideInterval, @)".}

type LerpBlendType* {.importcpp: "PT(LerpBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of TypedReferenceCount

converter toLerpBlendType*(_: type(nil)): LerpBlendType {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[LerpBlendType], obj: TypedObject): LerpBlendType {.importcpp: "DCAST(LerpBlendType, @)".}

type EaseInBlendType* {.importcpp: "PT(EaseInBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of LerpBlendType

converter toEaseInBlendType*(_: type(nil)): EaseInBlendType {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[EaseInBlendType], obj: TypedObject): EaseInBlendType {.importcpp: "DCAST(EaseInBlendType, @)".}

type EaseOutBlendType* {.importcpp: "PT(EaseOutBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of LerpBlendType

converter toEaseOutBlendType*(_: type(nil)): EaseOutBlendType {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[EaseOutBlendType], obj: TypedObject): EaseOutBlendType {.importcpp: "DCAST(EaseOutBlendType, @)".}

type EaseInOutBlendType* {.importcpp: "PT(EaseInOutBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of LerpBlendType

converter toEaseInOutBlendType*(_: type(nil)): EaseInOutBlendType {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[EaseInOutBlendType], obj: TypedObject): EaseInOutBlendType {.importcpp: "DCAST(EaseInOutBlendType, @)".}

type NoBlendType* {.importcpp: "PT(NoBlendType)", bycopy, pure, inheritable, header: "lerpblend.h".} = object of LerpBlendType

converter toNoBlendType*(_: type(nil)): NoBlendType {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[NoBlendType], obj: TypedObject): NoBlendType {.importcpp: "DCAST(NoBlendType, @)".}

type ShowInterval* {.importcpp: "PT(ShowInterval)", bycopy, pure, inheritable, header: "showInterval.h".} = object of CInterval

converter toShowInterval*(_: type(nil)): ShowInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[ShowInterval], obj: TypedObject): ShowInterval {.importcpp: "DCAST(ShowInterval, @)".}

type WaitInterval* {.importcpp: "PT(WaitInterval)", bycopy, pure, inheritable, header: "waitInterval.h".} = object of CInterval

converter toWaitInterval*(_: type(nil)): WaitInterval {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[WaitInterval], obj: TypedObject): WaitInterval {.importcpp: "DCAST(WaitInterval, @)".}

type CConnectionRepository* {.importcpp: "CConnectionRepository", pure, inheritable, header: "cConnectionRepository.h".} = object

type CDistributedSmoothNodeBase* {.importcpp: "CDistributedSmoothNodeBase", pure, inheritable, header: "cDistributedSmoothNodeBase.h".} = object

type CMotionTrail* {.importcpp: "PT(CMotionTrail)", bycopy, pure, inheritable, header: "cMotionTrail.h".} = object of TypedReferenceCount

converter toCMotionTrail*(_: type(nil)): CMotionTrail {.importcpp: "(nullptr)".}
func dcast*(_: typedesc[CMotionTrail], obj: TypedObject): CMotionTrail {.importcpp: "DCAST(CMotionTrail, @)".}

proc initDCPackData*(): DCPackData {.importcpp: "DCPackData()".}

proc initDCPackData*(param0: DCPackData): DCPackData {.importcpp: "DCPackData(#)".}

proc initDCPacker*(): DCPacker {.importcpp: "DCPacker()".}

proc initDCPacker*(param0: DCPacker): DCPacker {.importcpp: "DCPacker(#)".}

proc getNumStackElementsEverAllocated*(_: typedesc[DCPacker]): int {.importcpp: "DCPacker::get_num_stack_elements_ever_allocated()", header: "dcPacker.h".}

proc initDCFile*(): DCFile {.importcpp: "DCFile()".}

proc initDCFile*(param0: DCFile): DCFile {.importcpp: "DCFile(#)".}

proc getParticlePath*(): ConfigVariableSearchPath {.importcpp: "get_particle_path()", header: "showBase.h".}

proc throwNewFrame*() {.importcpp: "throw_new_frame()", header: "showBase.h".}

proc initAppForGui*() {.importcpp: "init_app_for_gui()", header: "showBase.h".}

proc addFullscreenTestsize*(xsize: int, ysize: int) {.importcpp: "add_fullscreen_testsize(#, #)", header: "showBase.h".}

proc runtestFullscreenSizes*(win: GraphicsWindow) {.importcpp: "runtest_fullscreen_sizes(#)", header: "showBase.h".}

proc queryFullscreenTestresult*(xsize: int, ysize: int): bool {.importcpp: "query_fullscreen_testresult(#, #)", header: "showBase.h".}

proc storeAccessibilityShortcutKeys*() {.importcpp: "store_accessibility_shortcut_keys()", header: "showBase.h".}

proc allowAccessibilityShortcutKeys*(allowKeys: bool) {.importcpp: "allow_accessibility_shortcut_keys(#)", header: "showBase.h".}

proc initSmoothMover*(): SmoothMover {.importcpp: "SmoothMover()".}

proc initSmoothMover*(param0: SmoothMover): SmoothMover {.importcpp: "SmoothMover(#)".}

proc newCIntervalManager*(): CIntervalManager {.importcpp: "new CIntervalManager()".}

proc getGlobalPtr*(_: typedesc[CIntervalManager]): CIntervalManager {.importcpp: "CIntervalManager::get_global_ptr()", header: "cIntervalManager.h".}

converter getClassType*(_: typedesc[CInterval]): TypeHandle {.importcpp: "CInterval::get_class_type()", header: "cInterval.h".}

proc newCInterval*(param0: CInterval): CInterval {.importcpp: "new CInterval(#)".}

converter getClassType*(_: typedesc[CConstraintInterval]): TypeHandle {.importcpp: "CConstraintInterval::get_class_type()", header: "cConstraintInterval.h".}

proc newCConstraintInterval*(param0: CConstraintInterval): CConstraintInterval {.importcpp: "new CConstraintInterval(#)".}

proc newCConstrainHprInterval*(param0: CConstrainHprInterval): CConstrainHprInterval {.importcpp: "new CConstrainHprInterval(#)".}

proc newCConstrainHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool, hprOffset: LVecBase3): CConstrainHprInterval {.importcpp: "new CConstrainHprInterval(nimStringToStdString(#), #, #, #, #, (LVecBase3 const &)(#))", header: stringConversionCode.}

proc newCConstrainHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool): CConstrainHprInterval {.importcpp: "new CConstrainHprInterval(nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.}

converter getClassType*(_: typedesc[CConstrainHprInterval]): TypeHandle {.importcpp: "CConstrainHprInterval::get_class_type()", header: "cConstrainHprInterval.h".}

proc newCConstrainPosHprInterval*(param0: CConstrainPosHprInterval): CConstrainPosHprInterval {.importcpp: "new CConstrainPosHprInterval(#)".}

proc newCConstrainPosHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool, posOffset: LVecBase3, hprOffset: LVecBase3): CConstrainPosHprInterval {.importcpp: "new CConstrainPosHprInterval(nimStringToStdString(#), #, #, #, #, (LVecBase3 const &)(#), (LVecBase3 const &)(#))", header: stringConversionCode.}

proc newCConstrainPosHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool, posOffset: LVecBase3): CConstrainPosHprInterval {.importcpp: "new CConstrainPosHprInterval(nimStringToStdString(#), #, #, #, #, (LVecBase3 const &)(#))", header: stringConversionCode.}

proc newCConstrainPosHprInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool): CConstrainPosHprInterval {.importcpp: "new CConstrainPosHprInterval(nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.}

converter getClassType*(_: typedesc[CConstrainPosHprInterval]): TypeHandle {.importcpp: "CConstrainPosHprInterval::get_class_type()", header: "cConstrainPosHprInterval.h".}

proc newCConstrainPosInterval*(param0: CConstrainPosInterval): CConstrainPosInterval {.importcpp: "new CConstrainPosInterval(#)".}

proc newCConstrainPosInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool, posOffset: LVecBase3): CConstrainPosInterval {.importcpp: "new CConstrainPosInterval(nimStringToStdString(#), #, #, #, #, (LVecBase3 const &)(#))", header: stringConversionCode.}

proc newCConstrainPosInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool): CConstrainPosInterval {.importcpp: "new CConstrainPosInterval(nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.}

converter getClassType*(_: typedesc[CConstrainPosInterval]): TypeHandle {.importcpp: "CConstrainPosInterval::get_class_type()", header: "cConstrainPosInterval.h".}

proc newCConstrainTransformInterval*(param0: CConstrainTransformInterval): CConstrainTransformInterval {.importcpp: "new CConstrainTransformInterval(#)".}

proc newCConstrainTransformInterval*(name: string, duration: float64, node: NodePath, target: NodePath, wrt: bool): CConstrainTransformInterval {.importcpp: "new CConstrainTransformInterval(nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.}

converter getClassType*(_: typedesc[CConstrainTransformInterval]): TypeHandle {.importcpp: "CConstrainTransformInterval::get_class_type()", header: "cConstrainTransformInterval.h".}

proc stringBlendType*(_: typedesc[CLerpInterval], blendType: string): CLerpInterval_BlendType {.importcpp: "#CLerpInterval::string_blend_type(nimStringToStdString(#))", header: "cLerpInterval.h".}

converter getClassType*(_: typedesc[CLerpInterval]): TypeHandle {.importcpp: "CLerpInterval::get_class_type()", header: "cLerpInterval.h".}

proc newCLerpInterval*(param0: CLerpInterval): CLerpInterval {.importcpp: "new CLerpInterval(#)".}

proc newCLerpAnimEffectInterval*(param0: CLerpAnimEffectInterval): CLerpAnimEffectInterval {.importcpp: "new CLerpAnimEffectInterval(#)".}

proc newCLerpAnimEffectInterval*(name: string, duration: float64, blendType: CLerpInterval_BlendType): CLerpAnimEffectInterval {.importcpp: "new CLerpAnimEffectInterval(nimStringToStdString(#), #, #)", header: stringConversionCode.}

converter getClassType*(_: typedesc[CLerpAnimEffectInterval]): TypeHandle {.importcpp: "CLerpAnimEffectInterval::get_class_type()", header: "cLerpAnimEffectInterval.h".}

proc newCLerpNodePathInterval*(param0: CLerpNodePathInterval): CLerpNodePathInterval {.importcpp: "new CLerpNodePathInterval(#)".}

proc newCLerpNodePathInterval*(name: string, duration: float64, blendType: CLerpInterval_BlendType, bakeInStart: bool, fluid: bool, node: NodePath, other: NodePath): CLerpNodePathInterval {.importcpp: "new CLerpNodePathInterval(nimStringToStdString(#), #, #, #, #, #, #)", header: stringConversionCode.}

converter getClassType*(_: typedesc[CLerpNodePathInterval]): TypeHandle {.importcpp: "CLerpNodePathInterval::get_class_type()", header: "cLerpNodePathInterval.h".}

proc newCMetaInterval*(param0: CMetaInterval): CMetaInterval {.importcpp: "new CMetaInterval(#)".}

proc newCMetaInterval*(name: string): CMetaInterval {.importcpp: "new CMetaInterval(nimStringToStdString(#))", header: stringConversionCode.}

converter getClassType*(_: typedesc[CMetaInterval]): TypeHandle {.importcpp: "CMetaInterval::get_class_type()", header: "cMetaInterval.h".}

proc newHideInterval*(param0: HideInterval): HideInterval {.importcpp: "new HideInterval(#)".}

proc newHideInterval*(node: NodePath, name: string): HideInterval {.importcpp: "new HideInterval(#, nimStringToStdString(#))", header: stringConversionCode.}

proc newHideInterval*(node: NodePath): HideInterval {.importcpp: "new HideInterval(#)".}

converter getClassType*(_: typedesc[HideInterval]): TypeHandle {.importcpp: "HideInterval::get_class_type()", header: "hideInterval.h".}

converter getClassType*(_: typedesc[LerpBlendType]): TypeHandle {.importcpp: "LerpBlendType::get_class_type()", header: "lerpblend.h".}

proc newEaseInBlendType*(): EaseInBlendType {.importcpp: "new EaseInBlendType()".}

converter getClassType*(_: typedesc[EaseInBlendType]): TypeHandle {.importcpp: "EaseInBlendType::get_class_type()", header: "lerpblend.h".}

proc newEaseOutBlendType*(): EaseOutBlendType {.importcpp: "new EaseOutBlendType()".}

converter getClassType*(_: typedesc[EaseOutBlendType]): TypeHandle {.importcpp: "EaseOutBlendType::get_class_type()", header: "lerpblend.h".}

proc newEaseInOutBlendType*(): EaseInOutBlendType {.importcpp: "new EaseInOutBlendType()".}

converter getClassType*(_: typedesc[EaseInOutBlendType]): TypeHandle {.importcpp: "EaseInOutBlendType::get_class_type()", header: "lerpblend.h".}

proc newNoBlendType*(): NoBlendType {.importcpp: "new NoBlendType()".}

converter getClassType*(_: typedesc[NoBlendType]): TypeHandle {.importcpp: "NoBlendType::get_class_type()", header: "lerpblend.h".}

proc newShowInterval*(node: NodePath, name: string): ShowInterval {.importcpp: "new ShowInterval(#, nimStringToStdString(#))", header: stringConversionCode.}

proc newShowInterval*(node: NodePath): ShowInterval {.importcpp: "new ShowInterval(#)".}

proc newShowInterval*(param0: ShowInterval): ShowInterval {.importcpp: "new ShowInterval(#)".}

converter getClassType*(_: typedesc[ShowInterval]): TypeHandle {.importcpp: "ShowInterval::get_class_type()", header: "showInterval.h".}

proc newWaitInterval*(param0: WaitInterval): WaitInterval {.importcpp: "new WaitInterval(#)".}

proc newWaitInterval*(duration: float64): WaitInterval {.importcpp: "new WaitInterval(#)".}

converter getClassType*(_: typedesc[WaitInterval]): TypeHandle {.importcpp: "WaitInterval::get_class_type()", header: "waitInterval.h".}

proc initCConnectionRepository*(hasOwnerView: bool, threadedNet: bool): CConnectionRepository {.importcpp: "CConnectionRepository(#, #)".}

proc initCConnectionRepository*(hasOwnerView: bool): CConnectionRepository {.importcpp: "CConnectionRepository(#)".}

proc initCConnectionRepository*(): CConnectionRepository {.importcpp: "CConnectionRepository()".}

proc getOverflowEventName*(_: typedesc[CConnectionRepository]): string {.importcpp: "nimStringFromStdString(CConnectionRepository::get_overflow_event_name())", header: "cConnectionRepository.h".}

proc initCDistributedSmoothNodeBase*(): CDistributedSmoothNodeBase {.importcpp: "CDistributedSmoothNodeBase()".}

proc initCDistributedSmoothNodeBase*(param0: CDistributedSmoothNodeBase): CDistributedSmoothNodeBase {.importcpp: "CDistributedSmoothNodeBase(#)".}

proc newCMotionTrail*(): CMotionTrail {.importcpp: "new CMotionTrail()".}

proc newCMotionTrail*(param0: CMotionTrail): CMotionTrail {.importcpp: "new CMotionTrail(#)".}

converter getClassType*(_: typedesc[CMotionTrail]): TypeHandle {.importcpp: "CMotionTrail::get_class_type()", header: "cMotionTrail.h".}

func name*(this: CInterval): string {.importcpp: "nimStringFromStdString(#->get_name())", header: stringConversionCode.}

func duration*(this: CInterval): float64 {.importcpp: "#->get_duration()".}

func openEnded*(this: CInterval): bool {.importcpp: "#->get_open_ended()".}

func state*(this: CInterval): CInterval_State {.importcpp: "#->get_state()".}

func stopped*(this: CInterval): bool {.importcpp: "#->is_stopped()".}

func doneEvent*(this: CInterval): string {.importcpp: "nimStringFromStdString(#->get_done_event())", header: stringConversionCode.}

proc `doneEvent=`*(this: CInterval, event: string) {.importcpp: "#->set_done_event(nimStringToStdString(#))", header: stringConversionCode.}

func t*(this: CInterval): float64 {.importcpp: "#->get_t()".}

proc `t=`*(this: CInterval, t: float64) {.importcpp: "#->set_t(#)".}

func autoPause*(this: CInterval): bool {.importcpp: "#->get_auto_pause()".}

proc `autoPause=`*(this: CInterval, autoPause: bool) {.importcpp: "#->set_auto_pause(#)".}

func autoFinish*(this: CInterval): bool {.importcpp: "#->get_auto_finish()".}

proc `autoFinish=`*(this: CInterval, autoFinish: bool) {.importcpp: "#->set_auto_finish(#)".}

func manager*(this: CInterval): CIntervalManager {.importcpp: "#->get_manager()".}

proc `manager=`*(this: CInterval, manager: CIntervalManager) {.importcpp: "#->set_manager(#)".}

func playRate*(this: CInterval): float64 {.importcpp: "#->get_play_rate()".}

proc `playRate=`*(this: CInterval, playRate: float64) {.importcpp: "#->set_play_rate(#)".}

func playing*(this: CInterval): bool {.importcpp: "#->is_playing()".}

proc getName*(this: CInterval | DCClass | DCKeyword | DCPackerInterface | DCSwitch | DCTypedef): string {.importcpp: "nimStringFromStdString(#->get_name())", header: stringConversionCode.}

proc findSeekIndex*(this: DCPackerInterface, name: string): int {.importcpp: "#->find_seek_index(nimStringToStdString(#))", header: stringConversionCode.}

proc asField*(this: DCField | DCPackerInterface): DCField {.importcpp: "#->as_field()".}

proc asSwitchParameter*(this: DCPackerInterface): DCSwitchParameter {.importcpp: "#->as_switch_parameter()".}

proc asClassParameter*(this: DCPackerInterface): DCClassParameter {.importcpp: "#->as_class_parameter()".}

proc checkMatch*(this: DCPackerInterface, other: DCPackerInterface): bool {.importcpp: "#->check_match(#)".}

proc checkMatch*(this: DCPackerInterface, description: string, dcfile: DCFile): bool {.importcpp: "#->check_match(nimStringToStdString(#), #)", header: stringConversionCode.}

proc checkMatch*(this: DCPackerInterface, description: string): bool {.importcpp: "#->check_match(nimStringToStdString(#))", header: stringConversionCode.}

proc hasKeyword*(this: DCKeywordList, keyword: DCKeyword): bool {.importcpp: "#.has_keyword(#)".}

proc hasKeyword*(this: DCKeywordList, name: string): bool {.importcpp: "#.has_keyword(nimStringToStdString(#))", header: stringConversionCode.}

proc getNumKeywords*(this: DCFile | DCKeywordList): int {.importcpp: "#.get_num_keywords()".}

proc getKeyword*(this: DCFile | DCKeywordList, n: int): DCKeyword {.importcpp: "#.get_keyword(#)".}

proc getKeywordByName*(this: DCFile | DCKeywordList, name: string): DCKeyword {.importcpp: "#.get_keyword_by_name(nimStringToStdString(#))", header: stringConversionCode.}

proc compareKeywords*(this: DCKeywordList, other: DCKeywordList): bool {.importcpp: "#.compare_keywords(#)".}

converter upcastToDCPackerInterface*(this: DCField): DCPackerInterface {.importcpp: "((DCPackerInterface *)(#))".}

converter upcastToDCKeywordList*(this: DCField): DCKeywordList {.importcpp: "((DCKeywordList *)(#))".}

proc getNumber*(this: DCClass | DCField | DCTypedef): int {.importcpp: "#->get_number()".}

proc getClass*(this: DCField): DCClass {.importcpp: "#->get_class()".}

proc asAtomicField*(this: DCField): DCAtomicField {.importcpp: "#->as_atomic_field()".}

proc asMolecularField*(this: DCField): DCMolecularField {.importcpp: "#->as_molecular_field()".}

proc asParameter*(this: DCField): DCParameter {.importcpp: "#->as_parameter()".}

proc hasDefaultValue*(this: DCField): bool {.importcpp: "#->has_default_value()".}

proc isBogusField*(this: DCField): bool {.importcpp: "#->is_bogus_field()".}

proc isRequired*(this: DCField): bool {.importcpp: "#->is_required()".}

proc isBroadcast*(this: DCField): bool {.importcpp: "#->is_broadcast()".}

proc isRam*(this: DCField): bool {.importcpp: "#->is_ram()".}

proc isDb*(this: DCField): bool {.importcpp: "#->is_db()".}

proc isClsend*(this: DCField): bool {.importcpp: "#->is_clsend()".}

proc isClrecv*(this: DCField): bool {.importcpp: "#->is_clrecv()".}

proc isOwnsend*(this: DCField): bool {.importcpp: "#->is_ownsend()".}

proc isOwnrecv*(this: DCField): bool {.importcpp: "#->is_ownrecv()".}

proc isAirecv*(this: DCField): bool {.importcpp: "#->is_airecv()".}

proc output*(this: CInterval | CIntervalManager | DCClass | DCDeclaration | DCField, `out`: ostream) {.importcpp: "#->output(#)".}

proc write*(this: CInterval | DCDeclaration | DCField, `out`: ostream, indentLevel: int) {.importcpp: "#->write(#, #)".}

proc clear*(this: DCFile | DCPackData) {.importcpp: "#.clear()".}

proc getString*(this: DCPackData | DCPacker): string {.importcpp: "nimStringFromStdString(#.get_string())", header: stringConversionCode.}

proc getLength*(this: DCPackData | DCPacker): int {.importcpp: "#.get_length()".}

proc clearData*(this: DCPacker) {.importcpp: "#.clear_data()".}

proc beginPack*(this: DCPacker, root: DCPackerInterface) {.importcpp: "#.begin_pack(#)".}

proc endPack*(this: DCPacker): bool {.importcpp: "#.end_pack()".}

proc beginUnpack*(this: DCPacker, root: DCPackerInterface) {.importcpp: "#.begin_unpack(#)".}

proc endUnpack*(this: DCPacker): bool {.importcpp: "#.end_unpack()".}

proc beginRepack*(this: DCPacker, root: DCPackerInterface) {.importcpp: "#.begin_repack(#)".}

proc endRepack*(this: DCPacker): bool {.importcpp: "#.end_repack()".}

proc seek*(this: DCPacker, seekIndex: int): bool {.importcpp: "#.seek(#)".}

proc seek*(this: DCPacker, fieldName: string): bool {.importcpp: "#.seek(nimStringToStdString(#))", header: stringConversionCode.}

proc hasNestedFields*(this: DCPacker): bool {.importcpp: "#.has_nested_fields()".}

proc getNumNestedFields*(this: DCPacker): int {.importcpp: "#.get_num_nested_fields()".}

proc moreNestedFields*(this: DCPacker): bool {.importcpp: "#.more_nested_fields()".}

proc getCurrentParent*(this: DCPacker): DCPackerInterface {.importcpp: "#.get_current_parent()".}

proc getCurrentField*(this: DCPacker): DCPackerInterface {.importcpp: "#.get_current_field()".}

proc getLastSwitch*(this: DCPacker): DCSwitchParameter {.importcpp: "#.get_last_switch()".}

proc getPackType*(this: DCPacker): DCPackType {.importcpp: "#.get_pack_type()".}

proc getCurrentFieldName*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.get_current_field_name())", header: stringConversionCode.}

proc push*(this: DCPacker) {.importcpp: "#.push()".}

proc pop*(this: DCPacker) {.importcpp: "#.pop()".}

proc packDouble*(this: DCPacker, value: float64) {.importcpp: "#.pack_double(#)".}

proc packInt*(this: DCPacker, value: int) {.importcpp: "#.pack_int(#)".}

proc packUint*(this: DCPacker, value: int) {.importcpp: "#.pack_uint(#)".}

proc packInt64*(this: DCPacker, value: clonglong) {.importcpp: "#.pack_int64(#)".}

proc packUint64*(this: DCPacker, value: clonglong) {.importcpp: "#.pack_uint64(#)".}

proc packString*(this: DCPacker, value: string) {.importcpp: "#.pack_string(nimStringToStdString(#))", header: stringConversionCode.}

proc packDefaultValue*(this: DCPacker) {.importcpp: "#.pack_default_value()".}

proc unpackDouble*(this: DCPacker): float64 {.importcpp: "#.unpack_double()".}

proc unpackInt*(this: DCPacker): int {.importcpp: "#.unpack_int()".}

proc unpackUint*(this: DCPacker): int {.importcpp: "#.unpack_uint()".}

proc unpackInt64*(this: DCPacker): clonglong {.importcpp: "#.unpack_int64()".}

proc unpackUint64*(this: DCPacker): clonglong {.importcpp: "#.unpack_uint64()".}

proc unpackString*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.unpack_string())", header: stringConversionCode.}

proc unpackValidate*(this: DCPacker) {.importcpp: "#.unpack_validate()".}

proc unpackSkip*(this: DCPacker) {.importcpp: "#.unpack_skip()".}

proc parseAndPack*(this: DCPacker, `in`: istream): bool {.importcpp: "#.parse_and_pack(#)".}

proc parseAndPack*(this: DCPacker, formattedObject: string): bool {.importcpp: "#.parse_and_pack(nimStringToStdString(#))", header: stringConversionCode.}

proc unpackAndFormat*(this: DCPacker, showFieldNames: bool): string {.importcpp: "nimStringFromStdString(#.unpack_and_format(#))", header: stringConversionCode.}

proc unpackAndFormat*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.unpack_and_format())", header: stringConversionCode.}

proc unpackAndFormat*(this: DCPacker, `out`: ostream, showFieldNames: bool) {.importcpp: "#.unpack_and_format(#, #)".}

proc unpackAndFormat*(this: DCPacker, `out`: ostream) {.importcpp: "#.unpack_and_format(#)".}

proc hadParseError*(this: DCPacker): bool {.importcpp: "#.had_parse_error()".}

proc hadPackError*(this: DCPacker): bool {.importcpp: "#.had_pack_error()".}

proc hadRangeError*(this: DCPacker): bool {.importcpp: "#.had_range_error()".}

proc hadError*(this: DCPacker): bool {.importcpp: "#.had_error()".}

proc getNumUnpackedBytes*(this: DCPacker): int {.importcpp: "#.get_num_unpacked_bytes()".}

proc getUnpackLength*(this: DCPacker): int {.importcpp: "#.get_unpack_length()".}

proc getUnpackString*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.get_unpack_string())", header: stringConversionCode.}

proc rawPackInt8*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_int8(#)".}

proc rawPackInt16*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_int16(#)".}

proc rawPackInt32*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_int32(#)".}

proc rawPackInt64*(this: DCPacker, value: clonglong) {.importcpp: "#.raw_pack_int64(#)".}

proc rawPackUint8*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_uint8(#)".}

proc rawPackUint16*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_uint16(#)".}

proc rawPackUint32*(this: DCPacker, value: int) {.importcpp: "#.raw_pack_uint32(#)".}

proc rawPackUint64*(this: DCPacker, value: clonglong) {.importcpp: "#.raw_pack_uint64(#)".}

proc rawPackFloat64*(this: DCPacker, value: float64) {.importcpp: "#.raw_pack_float64(#)".}

proc rawPackString*(this: DCPacker, value: string) {.importcpp: "#.raw_pack_string(nimStringToStdString(#))", header: stringConversionCode.}

proc rawUnpackInt8*(this: DCPacker): int {.importcpp: "#.raw_unpack_int8()".}

proc rawUnpackInt16*(this: DCPacker): int {.importcpp: "#.raw_unpack_int16()".}

proc rawUnpackInt32*(this: DCPacker): int {.importcpp: "#.raw_unpack_int32()".}

proc rawUnpackInt64*(this: DCPacker): clonglong {.importcpp: "#.raw_unpack_int64()".}

proc rawUnpackUint8*(this: DCPacker): int {.importcpp: "#.raw_unpack_uint8()".}

proc rawUnpackUint16*(this: DCPacker): int {.importcpp: "#.raw_unpack_uint16()".}

proc rawUnpackUint32*(this: DCPacker): int {.importcpp: "#.raw_unpack_uint32()".}

proc rawUnpackUint64*(this: DCPacker): clonglong {.importcpp: "#.raw_unpack_uint64()".}

proc rawUnpackFloat64*(this: DCPacker): float64 {.importcpp: "#.raw_unpack_float64()".}

proc rawUnpackString*(this: DCPacker): string {.importcpp: "nimStringFromStdString(#.raw_unpack_string())", header: stringConversionCode.}

proc asSimpleParameter*(this: DCParameter): DCSimpleParameter {.importcpp: "#->as_simple_parameter()".}

proc asArrayParameter*(this: DCParameter): DCArrayParameter {.importcpp: "#->as_array_parameter()".}

proc makeCopy*(this: DCParameter): DCParameter {.importcpp: "#->make_copy()".}

proc isValid*(this: DCParameter): bool {.importcpp: "#->is_valid()".}

proc getTypedef*(this: DCParameter): DCTypedef {.importcpp: "#->get_typedef()".}

proc getElementType*(this: DCArrayParameter): DCParameter {.importcpp: "#->get_element_type()".}

proc getArraySize*(this: DCArrayParameter): int {.importcpp: "#->get_array_size()".}

proc getNumElements*(this: DCAtomicField): int {.importcpp: "#->get_num_elements()".}

proc getElement*(this: DCAtomicField, n: int): DCParameter {.importcpp: "#->get_element(#)".}

proc hasElementDefault*(this: DCAtomicField, n: int): bool {.importcpp: "#->has_element_default(#)".}

proc getElementName*(this: DCAtomicField, n: int): string {.importcpp: "nimStringFromStdString(#->get_element_name(#))", header: stringConversionCode.}

proc getElementType*(this: DCAtomicField, n: int): DCSubatomicType {.importcpp: "#->get_element_type(#)".}

proc getElementDivisor*(this: DCAtomicField, n: int): int {.importcpp: "#->get_element_divisor(#)".}

proc asClass*(this: DCDeclaration): DCClass {.importcpp: "#->as_class()".}

proc asSwitch*(this: DCDeclaration): DCSwitch {.importcpp: "#->as_switch()".}

proc getDcFile*(this: DCClass): DCFile {.importcpp: "#->get_dc_file()".}

proc getNumParents*(this: DCClass): int {.importcpp: "#->get_num_parents()".}

proc getParent*(this: DCClass, n: int): DCClass {.importcpp: "#->get_parent(#)".}

proc hasConstructor*(this: DCClass): bool {.importcpp: "#->has_constructor()".}

proc getConstructor*(this: DCClass): DCField {.importcpp: "#->get_constructor()".}

proc getNumFields*(this: DCClass): int {.importcpp: "#->get_num_fields()".}

proc getField*(this: DCClass, n: int): DCField {.importcpp: "#->get_field(#)".}

proc getFieldByName*(this: DCClass, name: string): DCField {.importcpp: "#->get_field_by_name(nimStringToStdString(#))", header: stringConversionCode.}

proc getFieldByIndex*(this: DCClass, indexNumber: int): DCField {.importcpp: "#->get_field_by_index(#)".}

proc getNumInheritedFields*(this: DCClass): int {.importcpp: "#->get_num_inherited_fields()".}

proc getInheritedField*(this: DCClass, n: int): DCField {.importcpp: "#->get_inherited_field(#)".}

proc isStruct*(this: DCClass): bool {.importcpp: "#->is_struct()".}

proc isBogusClass*(this: DCClass): bool {.importcpp: "#->is_bogus_class()".}

proc inheritsFromBogusClass*(this: DCClass): bool {.importcpp: "#->inherits_from_bogus_class()".}

proc startGenerate*(this: DCClass) {.importcpp: "#->start_generate()".}

proc stopGenerate*(this: DCClass) {.importcpp: "#->stop_generate()".}

proc hasClassDef*(this: DCClass): bool {.importcpp: "#->has_class_def()".}

proc hasOwnerClassDef*(this: DCClass): bool {.importcpp: "#->has_owner_class_def()".}

proc getClass*(this: DCClassParameter): DCClass {.importcpp: "#.get_class()".}

proc readAll*(this: DCFile): bool {.importcpp: "#.read_all()".}

proc read*(this: DCFile, filename: Filename): bool {.importcpp: "#.read(#)".}

proc read*(this: DCFile, `in`: istream, filename: string): bool {.importcpp: "#.read(#, nimStringToStdString(#))", header: stringConversionCode.}

proc read*(this: DCFile, `in`: istream): bool {.importcpp: "#.read(#)".}

proc write*(this: DCFile, filename: Filename, brief: bool): bool {.importcpp: "#.write(#, #)".}

proc write*(this: DCFile, `out`: ostream, brief: bool): bool {.importcpp: "#.write(#, #)".}

proc getNumClasses*(this: DCFile): int {.importcpp: "#.get_num_classes()".}

proc getClass*(this: DCFile, n: int): DCClass {.importcpp: "#.get_class(#)".}

proc getClassByName*(this: DCFile, name: string): DCClass {.importcpp: "#.get_class_by_name(nimStringToStdString(#))", header: stringConversionCode.}

proc getSwitchByName*(this: DCFile, name: string): DCSwitch {.importcpp: "#.get_switch_by_name(nimStringToStdString(#))", header: stringConversionCode.}

proc getFieldByIndex*(this: DCFile, indexNumber: int): DCField {.importcpp: "#.get_field_by_index(#)".}

proc allObjectsValid*(this: DCFile): bool {.importcpp: "#.all_objects_valid()".}

proc getNumImportModules*(this: DCFile): int {.importcpp: "#.get_num_import_modules()".}

proc getImportModule*(this: DCFile, n: int): string {.importcpp: "nimStringFromStdString(#.get_import_module(#))", header: stringConversionCode.}

proc getNumImportSymbols*(this: DCFile, n: int): int {.importcpp: "#.get_num_import_symbols(#)".}

proc getImportSymbol*(this: DCFile, n: int, i: int): string {.importcpp: "nimStringFromStdString(#.get_import_symbol(#, #))", header: stringConversionCode.}

proc getNumTypedefs*(this: DCFile): int {.importcpp: "#.get_num_typedefs()".}

proc getTypedef*(this: DCFile, n: int): DCTypedef {.importcpp: "#.get_typedef(#)".}

proc getTypedefByName*(this: DCFile, name: string): DCTypedef {.importcpp: "#.get_typedef_by_name(nimStringToStdString(#))", header: stringConversionCode.}

proc getHash*(this: DCFile): int {.importcpp: "#.get_hash()".}

proc getNumAtomics*(this: DCMolecularField): int {.importcpp: "#.get_num_atomics()".}

proc getAtomic*(this: DCMolecularField, n: int): DCAtomicField {.importcpp: "#.get_atomic(#)".}

proc getType*(this: DCSimpleParameter): DCSubatomicType {.importcpp: "#.get_type()".}

proc hasModulus*(this: DCSimpleParameter): bool {.importcpp: "#.has_modulus()".}

proc getModulus*(this: DCSimpleParameter): float64 {.importcpp: "#.get_modulus()".}

proc getDivisor*(this: DCSimpleParameter): int {.importcpp: "#.get_divisor()".}

proc getKeyParameter*(this: DCSwitch): DCField {.importcpp: "#->get_key_parameter()".}

proc getNumCases*(this: DCSwitch): int {.importcpp: "#->get_num_cases()".}

proc getCase*(this: DCSwitch, n: int): DCPackerInterface {.importcpp: "#->get_case(#)".}

proc getDefaultCase*(this: DCSwitch): DCPackerInterface {.importcpp: "#->get_default_case()".}

proc getNumFields*(this: DCSwitch, caseIndex: int): int {.importcpp: "#->get_num_fields(#)".}

proc getField*(this: DCSwitch, caseIndex: int, n: int): DCField {.importcpp: "#->get_field(#, #)".}

proc getFieldByName*(this: DCSwitch, caseIndex: int, name: string): DCField {.importcpp: "#->get_field_by_name(#, nimStringToStdString(#))", header: stringConversionCode.}

proc getSwitch*(this: DCSwitchParameter): DCSwitch {.importcpp: "#.get_switch()".}

proc getDescription*(this: DCTypedef): string {.importcpp: "nimStringFromStdString(#->get_description())", header: stringConversionCode.}

proc isBogusTypedef*(this: DCTypedef): bool {.importcpp: "#->is_bogus_typedef()".}

proc isImplicitTypedef*(this: DCTypedef): bool {.importcpp: "#->is_implicit_typedef()".}

proc setPos*(this: SmoothMover, pos: LVecBase3): bool {.importcpp: "#.set_pos((LVecBase3 const &)(#))".}

proc setPos*(this: SmoothMover, x: float, y: float, z: float): bool {.importcpp: "#.set_pos(#, #, #)".}

proc setX*(this: SmoothMover, x: float): bool {.importcpp: "#.set_x(#)".}

proc setY*(this: SmoothMover, y: float): bool {.importcpp: "#.set_y(#)".}

proc setZ*(this: SmoothMover, z: float): bool {.importcpp: "#.set_z(#)".}

proc setHpr*(this: SmoothMover, hpr: LVecBase3): bool {.importcpp: "#.set_hpr((LVecBase3 const &)(#))".}

proc setHpr*(this: SmoothMover, h: float, p: float, r: float): bool {.importcpp: "#.set_hpr(#, #, #)".}

proc setH*(this: SmoothMover, h: float): bool {.importcpp: "#.set_h(#)".}

proc setP*(this: SmoothMover, p: float): bool {.importcpp: "#.set_p(#)".}

proc setR*(this: SmoothMover, r: float): bool {.importcpp: "#.set_r(#)".}

proc setPosHpr*(this: SmoothMover, pos: LVecBase3, hpr: LVecBase3): bool {.importcpp: "#.set_pos_hpr((LVecBase3 const &)(#), (LVecBase3 const &)(#))".}

proc setPosHpr*(this: SmoothMover, x: float, y: float, z: float, h: float, p: float, r: float): bool {.importcpp: "#.set_pos_hpr(#, #, #, #, #, #)".}

proc getSamplePos*(this: SmoothMover): LPoint3 {.importcpp: "#.get_sample_pos()".}

proc getSampleHpr*(this: SmoothMover): LVecBase3 {.importcpp: "#.get_sample_hpr()".}

proc setPhonyTimestamp*(this: SmoothMover, timestamp: float64, periodAdjust: bool) {.importcpp: "#.set_phony_timestamp(#, #)".}

proc setPhonyTimestamp*(this: SmoothMover, timestamp: float64) {.importcpp: "#.set_phony_timestamp(#)".}

proc setPhonyTimestamp*(this: SmoothMover) {.importcpp: "#.set_phony_timestamp()".}

proc setTimestamp*(this: SmoothMover, timestamp: float64) {.importcpp: "#.set_timestamp(#)".}

proc hasMostRecentTimestamp*(this: SmoothMover): bool {.importcpp: "#.has_most_recent_timestamp()".}

proc getMostRecentTimestamp*(this: SmoothMover): float64 {.importcpp: "#.get_most_recent_timestamp()".}

proc markPosition*(this: SmoothMover) {.importcpp: "#.mark_position()".}

proc clearPositions*(this: SmoothMover, resetVelocity: bool) {.importcpp: "#.clear_positions(#)".}

proc computeSmoothPosition*(this: SmoothMover): bool {.importcpp: "#.compute_smooth_position()".}

proc computeSmoothPosition*(this: SmoothMover, timestamp: float64): bool {.importcpp: "#.compute_smooth_position(#)".}

proc getLatestPosition*(this: SmoothMover): bool {.importcpp: "#.get_latest_position()".}

proc getSmoothPos*(this: SmoothMover): LPoint3 {.importcpp: "#.get_smooth_pos()".}

proc getSmoothHpr*(this: SmoothMover): LVecBase3 {.importcpp: "#.get_smooth_hpr()".}

proc applySmoothPos*(this: SmoothMover, node: NodePath) {.importcpp: "#.apply_smooth_pos(#)".}

proc applySmoothPosHpr*(this: SmoothMover, posNode: NodePath, hprNode: NodePath) {.importcpp: "#.apply_smooth_pos_hpr(#, #)".}

proc applySmoothHpr*(this: SmoothMover, node: NodePath) {.importcpp: "#.apply_smooth_hpr(#)".}

proc computeAndApplySmoothPos*(this: SmoothMover, node: NodePath) {.importcpp: "#.compute_and_apply_smooth_pos(#)".}

proc computeAndApplySmoothPosHpr*(this: SmoothMover, posNode: NodePath, hprNode: NodePath) {.importcpp: "#.compute_and_apply_smooth_pos_hpr(#, #)".}

proc computeAndApplySmoothHpr*(this: SmoothMover, hprNode: NodePath) {.importcpp: "#.compute_and_apply_smooth_hpr(#)".}

proc getSmoothForwardVelocity*(this: SmoothMover): float {.importcpp: "#.get_smooth_forward_velocity()".}

proc getSmoothLateralVelocity*(this: SmoothMover): float {.importcpp: "#.get_smooth_lateral_velocity()".}

proc getSmoothRotationalVelocity*(this: SmoothMover): float {.importcpp: "#.get_smooth_rotational_velocity()".}

proc getForwardAxis*(this: SmoothMover): LVecBase3 {.importcpp: "#.get_forward_axis()".}

proc handleWrtReparent*(this: SmoothMover, oldParent: NodePath, newParent: NodePath) {.importcpp: "#.handle_wrt_reparent(#, #)".}

proc setSmoothMode*(this: SmoothMover, mode: SmoothMover_SmoothMode) {.importcpp: "#.set_smooth_mode(#)".}

proc getSmoothMode*(this: SmoothMover): SmoothMover_SmoothMode {.importcpp: "#.get_smooth_mode()".}

proc setPredictionMode*(this: SmoothMover, mode: SmoothMover_PredictionMode) {.importcpp: "#.set_prediction_mode(#)".}

proc getPredictionMode*(this: SmoothMover): SmoothMover_PredictionMode {.importcpp: "#.get_prediction_mode()".}

proc setDelay*(this: SmoothMover, delay: float64) {.importcpp: "#.set_delay(#)".}

proc getDelay*(this: SmoothMover): float64 {.importcpp: "#.get_delay()".}

proc setAcceptClockSkew*(this: SmoothMover, flag: bool) {.importcpp: "#.set_accept_clock_skew(#)".}

proc getAcceptClockSkew*(this: SmoothMover): bool {.importcpp: "#.get_accept_clock_skew()".}

proc setMaxPositionAge*(this: SmoothMover, age: float64) {.importcpp: "#.set_max_position_age(#)".}

proc getMaxPositionAge*(this: SmoothMover): float64 {.importcpp: "#.get_max_position_age()".}

proc setExpectedBroadcastPeriod*(this: SmoothMover, period: float64) {.importcpp: "#.set_expected_broadcast_period(#)".}

proc getExpectedBroadcastPeriod*(this: SmoothMover): float64 {.importcpp: "#.get_expected_broadcast_period()".}

proc setResetVelocityAge*(this: SmoothMover, age: float64) {.importcpp: "#.set_reset_velocity_age(#)".}

proc getResetVelocityAge*(this: SmoothMover): float64 {.importcpp: "#.get_reset_velocity_age()".}

proc setDirectionalVelocity*(this: SmoothMover, flag: bool) {.importcpp: "#.set_directional_velocity(#)".}

proc getDirectionalVelocity*(this: SmoothMover): bool {.importcpp: "#.get_directional_velocity()".}

proc setDefaultToStandingStill*(this: SmoothMover, flag: bool) {.importcpp: "#.set_default_to_standing_still(#)".}

proc getDefaultToStandingStill*(this: SmoothMover): bool {.importcpp: "#.get_default_to_standing_still()".}

proc output*(this: SmoothMover, `out`: ostream) {.importcpp: "#.output(#)".}

proc write*(this: SmoothMover, `out`: ostream) {.importcpp: "#.write(#)".}

proc getDuration*(this: CInterval): float64 {.importcpp: "#->get_duration()".}

proc getOpenEnded*(this: CInterval): bool {.importcpp: "#->get_open_ended()".}

proc getState*(this: CInterval): CInterval_State {.importcpp: "#->get_state()".}

proc isStopped*(this: CInterval): bool {.importcpp: "#->is_stopped()".}

proc setDoneEvent*(this: CInterval, event: string) {.importcpp: "#->set_done_event(nimStringToStdString(#))", header: stringConversionCode.}

proc getDoneEvent*(this: CInterval): string {.importcpp: "nimStringFromStdString(#->get_done_event())", header: stringConversionCode.}

proc setT*(this: CInterval, t: float64) {.importcpp: "#->set_t(#)".}

proc getT*(this: CInterval): float64 {.importcpp: "#->get_t()".}

proc setAutoPause*(this: CInterval, autoPause: bool) {.importcpp: "#->set_auto_pause(#)".}

proc getAutoPause*(this: CInterval): bool {.importcpp: "#->get_auto_pause()".}

proc setAutoFinish*(this: CInterval, autoFinish: bool) {.importcpp: "#->set_auto_finish(#)".}

proc getAutoFinish*(this: CInterval): bool {.importcpp: "#->get_auto_finish()".}

proc setWantsTCallback*(this: CInterval, wantsTCallback: bool) {.importcpp: "#->set_wants_t_callback(#)".}

proc getWantsTCallback*(this: CInterval): bool {.importcpp: "#->get_wants_t_callback()".}

proc setManager*(this: CInterval, manager: CIntervalManager) {.importcpp: "#->set_manager(#)".}

proc getManager*(this: CInterval): CIntervalManager {.importcpp: "#->get_manager()".}

proc start*(this: CInterval, startT: float64, endT: float64, playRate: float64) {.importcpp: "#->start(#, #, #)".}

proc start*(this: CInterval, startT: float64, endT: float64) {.importcpp: "#->start(#, #)".}

proc start*(this: CInterval, startT: float64) {.importcpp: "#->start(#)".}

proc start*(this: CInterval) {.importcpp: "#->start()".}

proc loop*(this: CInterval, startT: float64, endT: float64, playRate: float64) {.importcpp: "#->loop(#, #, #)".}

proc loop*(this: CInterval, startT: float64, endT: float64) {.importcpp: "#->loop(#, #)".}

proc loop*(this: CInterval, startT: float64) {.importcpp: "#->loop(#)".}

proc loop*(this: CInterval) {.importcpp: "#->loop()".}

proc pause*(this: CInterval): float64 {.importcpp: "#->pause()".}

proc resume*(this: CInterval) {.importcpp: "#->resume()".}

proc resume*(this: CInterval, startT: float64) {.importcpp: "#->resume(#)".}

proc resumeUntil*(this: CInterval, endT: float64) {.importcpp: "#->resume_until(#)".}

proc finish*(this: CInterval) {.importcpp: "#->finish()".}

proc clearToInitial*(this: CInterval) {.importcpp: "#->clear_to_initial()".}

proc isPlaying*(this: CInterval): bool {.importcpp: "#->is_playing()".}

proc getPlayRate*(this: CInterval): float64 {.importcpp: "#->get_play_rate()".}

proc setPlayRate*(this: CInterval, playRate: float64) {.importcpp: "#->set_play_rate(#)".}

proc privDoEvent*(this: CInterval, t: float64, event: CInterval_EventType) {.importcpp: "#->priv_do_event(#, #)".}

proc privInitialize*(this: CInterval, t: float64) {.importcpp: "#->priv_initialize(#)".}

proc privInstant*(this: CInterval) {.importcpp: "#->priv_instant()".}

proc privStep*(this: CInterval, t: float64) {.importcpp: "#->priv_step(#)".}

proc privFinalize*(this: CInterval) {.importcpp: "#->priv_finalize()".}

proc privReverseInitialize*(this: CInterval, t: float64) {.importcpp: "#->priv_reverse_initialize(#)".}

proc privReverseInstant*(this: CInterval) {.importcpp: "#->priv_reverse_instant()".}

proc privReverseFinalize*(this: CInterval) {.importcpp: "#->priv_reverse_finalize()".}

proc privInterrupt*(this: CInterval) {.importcpp: "#->priv_interrupt()".}

proc setupPlay*(this: CInterval, startTime: float64, endTime: float64, playRate: float64, doLoop: bool) {.importcpp: "#->setup_play(#, #, #, #)".}

proc setupResume*(this: CInterval) {.importcpp: "#->setup_resume()".}

proc setupResumeUntil*(this: CInterval, endT: float64) {.importcpp: "#->setup_resume_until(#)".}

proc stepPlay*(this: CInterval): bool {.importcpp: "#->step_play()".}

proc setEventQueue*(this: CIntervalManager, eventQueue: EventQueue) {.importcpp: "#->set_event_queue(#)".}

proc getEventQueue*(this: CIntervalManager): EventQueue {.importcpp: "#->get_event_queue()".}

proc addCInterval*(this: CIntervalManager, interval: CInterval, external: bool): int {.importcpp: "#->add_c_interval(#, #)".}

proc findCInterval*(this: CIntervalManager, name: string): int {.importcpp: "#->find_c_interval(nimStringToStdString(#))", header: stringConversionCode.}

proc getCInterval*(this: CIntervalManager, index: int): CInterval {.importcpp: "#->get_c_interval(#)".}

proc removeCInterval*(this: CIntervalManager, index: int) {.importcpp: "#->remove_c_interval(#)".}

proc interrupt*(this: CIntervalManager): int {.importcpp: "#->interrupt()".}

proc getNumIntervals*(this: CIntervalManager): int {.importcpp: "#->get_num_intervals()".}

proc getMaxIndex*(this: CIntervalManager): int {.importcpp: "#->get_max_index()".}

proc step*(this: CIntervalManager) {.importcpp: "#->step()".}

proc getNextEvent*(this: CIntervalManager): int {.importcpp: "#->get_next_event()".}

proc getNextRemoval*(this: CIntervalManager): int {.importcpp: "#->get_next_removal()".}

proc write*(this: CIntervalManager, `out`: ostream) {.importcpp: "#->write(#)".}

proc getNode*(this: CConstrainHprInterval | CConstrainPosHprInterval | CConstrainPosInterval | CConstrainTransformInterval | CLerpNodePathInterval): NodePath {.importcpp: "#->get_node()".}

proc getTarget*(this: CConstrainHprInterval | CConstrainPosHprInterval | CConstrainPosInterval | CConstrainTransformInterval): NodePath {.importcpp: "#->get_target()".}

proc getBlendType*(this: CLerpInterval): CLerpInterval_BlendType {.importcpp: "#->get_blend_type()".}

proc addControl*(this: CLerpAnimEffectInterval, control: AnimControl, name: string, beginEffect: float32, endEffect: float32) {.importcpp: "#->add_control(#, nimStringToStdString(#), #, #)", header: stringConversionCode.}

proc getOther*(this: CLerpNodePathInterval): NodePath {.importcpp: "#->get_other()".}

proc setStartPos*(this: CLerpNodePathInterval, pos: LVecBase3) {.importcpp: "#->set_start_pos((LVecBase3 const &)(#))".}

proc setEndPos*(this: CLerpNodePathInterval, pos: LVecBase3) {.importcpp: "#->set_end_pos((LVecBase3 const &)(#))".}

proc setStartHpr*(this: CLerpNodePathInterval, hpr: LVecBase3) {.importcpp: "#->set_start_hpr((LVecBase3 const &)(#))".}

proc setEndHpr*(this: CLerpNodePathInterval, quat: LQuaternion) {.importcpp: "#->set_end_hpr(#)".}

proc setEndHpr*(this: CLerpNodePathInterval, hpr: LVecBase3) {.importcpp: "#->set_end_hpr((LVecBase3 const &)(#))".}

proc setStartQuat*(this: CLerpNodePathInterval, quat: LQuaternion) {.importcpp: "#->set_start_quat(#)".}

proc setEndQuat*(this: CLerpNodePathInterval, quat: LQuaternion) {.importcpp: "#->set_end_quat(#)".}

proc setEndQuat*(this: CLerpNodePathInterval, hpr: LVecBase3) {.importcpp: "#->set_end_quat((LVecBase3 const &)(#))".}

proc setStartScale*(this: CLerpNodePathInterval, scale: LVecBase3) {.importcpp: "#->set_start_scale((LVecBase3 const &)(#))".}

proc setStartScale*(this: CLerpNodePathInterval, scale: float) {.importcpp: "#->set_start_scale(#)".}

proc setEndScale*(this: CLerpNodePathInterval, scale: LVecBase3) {.importcpp: "#->set_end_scale((LVecBase3 const &)(#))".}

proc setEndScale*(this: CLerpNodePathInterval, scale: float) {.importcpp: "#->set_end_scale(#)".}

proc setStartShear*(this: CLerpNodePathInterval, shear: LVecBase3) {.importcpp: "#->set_start_shear((LVecBase3 const &)(#))".}

proc setEndShear*(this: CLerpNodePathInterval, shear: LVecBase3) {.importcpp: "#->set_end_shear((LVecBase3 const &)(#))".}

proc setStartColor*(this: CLerpNodePathInterval, color: LVecBase4) {.importcpp: "#->set_start_color((LVecBase4 const &)(#))".}

proc setEndColor*(this: CLerpNodePathInterval, color: LVecBase4) {.importcpp: "#->set_end_color((LVecBase4 const &)(#))".}

proc setStartColorScale*(this: CLerpNodePathInterval, colorScale: LVecBase4) {.importcpp: "#->set_start_color_scale((LVecBase4 const &)(#))".}

proc setEndColorScale*(this: CLerpNodePathInterval, colorScale: LVecBase4) {.importcpp: "#->set_end_color_scale((LVecBase4 const &)(#))".}

proc setTextureStage*(this: CLerpNodePathInterval, stage: TextureStage) {.importcpp: "#->set_texture_stage(#)".}

proc setStartTexOffset*(this: CLerpNodePathInterval, texOffset: LVecBase2) {.importcpp: "#->set_start_tex_offset((LVecBase2 const &)(#))".}

proc setEndTexOffset*(this: CLerpNodePathInterval, texOffset: LVecBase2) {.importcpp: "#->set_end_tex_offset((LVecBase2 const &)(#))".}

proc setStartTexRotate*(this: CLerpNodePathInterval, texRotate: float) {.importcpp: "#->set_start_tex_rotate(#)".}

proc setEndTexRotate*(this: CLerpNodePathInterval, texRotate: float) {.importcpp: "#->set_end_tex_rotate(#)".}

proc setStartTexScale*(this: CLerpNodePathInterval, texScale: LVecBase2) {.importcpp: "#->set_start_tex_scale((LVecBase2 const &)(#))".}

proc setEndTexScale*(this: CLerpNodePathInterval, texScale: LVecBase2) {.importcpp: "#->set_end_tex_scale((LVecBase2 const &)(#))".}

proc setOverride*(this: CLerpNodePathInterval, override: int) {.importcpp: "#->set_override(#)".}

proc getOverride*(this: CLerpNodePathInterval): int {.importcpp: "#->get_override()".}

proc setPrecision*(this: CMetaInterval, precision: float64) {.importcpp: "#->set_precision(#)".}

proc getPrecision*(this: CMetaInterval): float64 {.importcpp: "#->get_precision()".}

proc clearIntervals*(this: CMetaInterval) {.importcpp: "#->clear_intervals()".}

proc pushLevel*(this: CMetaInterval, name: string, relTime: float64, relTo: CMetaInterval_RelativeStart): int {.importcpp: "#->push_level(nimStringToStdString(#), #, #)", header: stringConversionCode.}

proc addCInterval*(this: CMetaInterval, cInterval: CInterval, relTime: float64, relTo: CMetaInterval_RelativeStart): int {.importcpp: "#->add_c_interval(#, #, #)".}

proc addCInterval*(this: CMetaInterval, cInterval: CInterval, relTime: float64): int {.importcpp: "#->add_c_interval(#, #)".}

proc addCInterval*(this: CMetaInterval, cInterval: CInterval): int {.importcpp: "#->add_c_interval(#)".}

proc addExtIndex*(this: CMetaInterval, extIndex: int, name: string, duration: float64, openEnded: bool, relTime: float64, relTo: CMetaInterval_RelativeStart): int {.importcpp: "#->add_ext_index(#, nimStringToStdString(#), #, #, #, #)", header: stringConversionCode.}

proc popLevel*(this: CMetaInterval, duration: float64): int {.importcpp: "#->pop_level(#)".}

proc popLevel*(this: CMetaInterval): int {.importcpp: "#->pop_level()".}

proc setIntervalStartTime*(this: CMetaInterval, name: string, relTime: float64, relTo: CMetaInterval_RelativeStart): bool {.importcpp: "#->set_interval_start_time(nimStringToStdString(#), #, #)", header: stringConversionCode.}

proc setIntervalStartTime*(this: CMetaInterval, name: string, relTime: float64): bool {.importcpp: "#->set_interval_start_time(nimStringToStdString(#), #)", header: stringConversionCode.}

proc getIntervalStartTime*(this: CMetaInterval, name: string): float64 {.importcpp: "#->get_interval_start_time(nimStringToStdString(#))", header: stringConversionCode.}

proc getIntervalEndTime*(this: CMetaInterval, name: string): float64 {.importcpp: "#->get_interval_end_time(nimStringToStdString(#))", header: stringConversionCode.}

proc getNumDefs*(this: CMetaInterval): int {.importcpp: "#->get_num_defs()".}

proc getDefType*(this: CMetaInterval, n: int): CMetaInterval_DefType {.importcpp: "#->get_def_type(#)".}

proc getCInterval*(this: CMetaInterval, n: int): CInterval {.importcpp: "#->get_c_interval(#)".}

proc getExtIndex*(this: CMetaInterval, n: int): int {.importcpp: "#->get_ext_index(#)".}

proc isEventReady*(this: CMetaInterval): bool {.importcpp: "#->is_event_ready()".}

proc getEventIndex*(this: CMetaInterval): int {.importcpp: "#->get_event_index()".}

proc getEventT*(this: CMetaInterval): float64 {.importcpp: "#->get_event_t()".}

proc getEventType*(this: CMetaInterval): CInterval_EventType {.importcpp: "#->get_event_type()".}

proc popEvent*(this: CMetaInterval) {.importcpp: "#->pop_event()".}

proc timeline*(this: CMetaInterval, `out`: ostream) {.importcpp: "#->timeline(#)".}

proc getDcFile*(this: CConnectionRepository): DCFile {.importcpp: "#.get_dc_file()".}

proc hasOwnerView*(this: CConnectionRepository): bool {.importcpp: "#.has_owner_view()".}

proc setHandleCUpdates*(this: CConnectionRepository, handleCUpdates: bool) {.importcpp: "#.set_handle_c_updates(#)".}

proc getHandleCUpdates*(this: CConnectionRepository): bool {.importcpp: "#.get_handle_c_updates()".}

proc setClientDatagram*(this: CConnectionRepository, clientDatagram: bool) {.importcpp: "#.set_client_datagram(#)".}

proc getClientDatagram*(this: CConnectionRepository): bool {.importcpp: "#.get_client_datagram()".}

proc setHandleDatagramsInternally*(this: CConnectionRepository, handleDatagramsInternally: bool) {.importcpp: "#.set_handle_datagrams_internally(#)".}

proc getHandleDatagramsInternally*(this: CConnectionRepository): bool {.importcpp: "#.get_handle_datagrams_internally()".}

proc setTcpHeaderSize*(this: CConnectionRepository, tcpHeaderSize: int) {.importcpp: "#.set_tcp_header_size(#)".}

proc getTcpHeaderSize*(this: CConnectionRepository): int {.importcpp: "#.get_tcp_header_size()".}

proc setConnectionHttp*(this: CConnectionRepository, channel: HTTPChannel) {.importcpp: "#.set_connection_http(#)".}

proc getStream*(this: CConnectionRepository): SocketStream {.importcpp: "#.get_stream()".}

proc tryConnectNet*(this: CConnectionRepository, url: URLSpec): bool {.importcpp: "#.try_connect_net(#)".}

proc getQcm*(this: CConnectionRepository): QueuedConnectionManager {.importcpp: "#.get_qcm()".}

proc getCw*(this: CConnectionRepository): ConnectionWriter {.importcpp: "#.get_cw()".}

proc getQcr*(this: CConnectionRepository): QueuedConnectionReader {.importcpp: "#.get_qcr()".}

proc connectNative*(this: CConnectionRepository, url: URLSpec): bool {.importcpp: "#.connect_native(#)".}

proc getBdc*(this: CConnectionRepository): Buffered_DatagramConnection {.importcpp: "#.get_bdc()".}

proc checkDatagram*(this: CConnectionRepository): bool {.importcpp: "#.check_datagram()".}

proc getDatagram*(this: CConnectionRepository, dg: Datagram) {.importcpp: "#.get_datagram(#)".}

proc getDatagramIterator*(this: CConnectionRepository, di: DatagramIterator) {.importcpp: "#.get_datagram_iterator(#)".}

proc getMsgChannel*(this: CConnectionRepository, offset: int): clonglong {.importcpp: "#.get_msg_channel(#)".}

proc getMsgChannel*(this: CConnectionRepository): clonglong {.importcpp: "#.get_msg_channel()".}

proc getMsgChannelCount*(this: CConnectionRepository): int {.importcpp: "#.get_msg_channel_count()".}

proc getMsgSender*(this: CConnectionRepository): clonglong {.importcpp: "#.get_msg_sender()".}

proc getMsgType*(this: CConnectionRepository): int {.importcpp: "#.get_msg_type()".}

proc isConnected*(this: CConnectionRepository): bool {.importcpp: "#.is_connected()".}

proc sendDatagram*(this: CConnectionRepository, dg: Datagram): bool {.importcpp: "#.send_datagram(#)".}

proc setWantMessageBundling*(this: CConnectionRepository, flag: bool) {.importcpp: "#.set_want_message_bundling(#)".}

proc getWantMessageBundling*(this: CConnectionRepository): bool {.importcpp: "#.get_want_message_bundling()".}

proc setInQuietZone*(this: CConnectionRepository, flag: bool) {.importcpp: "#.set_in_quiet_zone(#)".}

proc getInQuietZone*(this: CConnectionRepository): bool {.importcpp: "#.get_in_quiet_zone()".}

proc startMessageBundle*(this: CConnectionRepository) {.importcpp: "#.start_message_bundle()".}

proc isBundlingMessages*(this: CConnectionRepository): bool {.importcpp: "#.is_bundling_messages()".}

proc sendMessageBundle*(this: CConnectionRepository, channel: int, senderChannel: int) {.importcpp: "#.send_message_bundle(#, #)".}

proc abandonMessageBundles*(this: CConnectionRepository) {.importcpp: "#.abandon_message_bundles()".}

proc bundleMsg*(this: CConnectionRepository, dg: Datagram) {.importcpp: "#.bundle_msg(#)".}

proc considerFlush*(this: CConnectionRepository): bool {.importcpp: "#.consider_flush()".}

proc flush*(this: CConnectionRepository): bool {.importcpp: "#.flush()".}

proc disconnect*(this: CConnectionRepository) {.importcpp: "#.disconnect()".}

proc shutdown*(this: CConnectionRepository) {.importcpp: "#.shutdown()".}

proc setSimulatedDisconnect*(this: CConnectionRepository, simulatedDisconnect: bool) {.importcpp: "#.set_simulated_disconnect(#)".}

proc getSimulatedDisconnect*(this: CConnectionRepository): bool {.importcpp: "#.get_simulated_disconnect()".}

proc toggleVerbose*(this: CConnectionRepository) {.importcpp: "#.toggle_verbose()".}

proc setVerbose*(this: CConnectionRepository, verbose: bool) {.importcpp: "#.set_verbose(#)".}

proc getVerbose*(this: CConnectionRepository): bool {.importcpp: "#.get_verbose()".}

proc setTimeWarning*(this: CConnectionRepository, timeWarning: float32) {.importcpp: "#.set_time_warning(#)".}

proc getTimeWarning*(this: CConnectionRepository): float32 {.importcpp: "#.get_time_warning()".}

proc setRepository*(this: CDistributedSmoothNodeBase, repository: CConnectionRepository, isAi: bool, aiId: clonglong) {.importcpp: "#.set_repository(#, #, #)".}

proc initialize*(this: CDistributedSmoothNodeBase, nodePath: NodePath, dclass: DCClass, doId: clonglong) {.importcpp: "#.initialize(#, #, #)".}

proc sendEverything*(this: CDistributedSmoothNodeBase) {.importcpp: "#.send_everything()".}

proc broadcastPosHprFull*(this: CDistributedSmoothNodeBase) {.importcpp: "#.broadcast_pos_hpr_full()".}

proc broadcastPosHprXyh*(this: CDistributedSmoothNodeBase) {.importcpp: "#.broadcast_pos_hpr_xyh()".}

proc broadcastPosHprXy*(this: CDistributedSmoothNodeBase) {.importcpp: "#.broadcast_pos_hpr_xy()".}

proc setCurrL*(this: CDistributedSmoothNodeBase, l: clonglong) {.importcpp: "#.set_curr_l(#)".}

proc printCurrL*(this: CDistributedSmoothNodeBase) {.importcpp: "#.print_curr_l()".}

proc reset*(this: CMotionTrail) {.importcpp: "#->reset()".}

proc resetVertexList*(this: CMotionTrail) {.importcpp: "#->reset_vertex_list()".}

proc enable*(this: CMotionTrail, enable: bool) {.importcpp: "#->enable(#)".}

proc setGeomNode*(this: CMotionTrail, geomNode: GeomNode) {.importcpp: "#->set_geom_node(#)".}

proc addVertex*(this: CMotionTrail, vertex: LVector4, startColor: LVector4, endColor: LVector4, v: float) {.importcpp: "#->add_vertex((LVector4 &)(#), (LVector4 &)(#), (LVector4 &)(#), #)".}

proc setParameters*(this: CMotionTrail, samplingTime: float, timeWindow: float, useTexture: bool, calculateRelativeMatrix: bool, useNurbs: bool, resolutionDistance: float) {.importcpp: "#->set_parameters(#, #, #, #, #, #)".}

proc checkForUpdate*(this: CMotionTrail, currentTime: float): int {.importcpp: "#->check_for_update(#)".}

proc updateMotionTrail*(this: CMotionTrail, currentTime: float, transform: LMatrix4) {.importcpp: "#->update_motion_trail(#, #)".}

func `$`*(this: CInterval | CIntervalManager | DCClass | DCDeclaration | DCField | SmoothMover): string {.inline.} =
  var str : StringStream
  this.output(str)
  str.data

converter toBool*(this: CConstrainHprInterval | CConstrainPosHprInterval | CConstrainPosInterval | CConstrainTransformInterval | CConstraintInterval | CInterval | CIntervalManager | CLerpAnimEffectInterval | CLerpInterval | CLerpNodePathInterval | CMetaInterval | CMotionTrail | DCArrayParameter | DCAtomicField | DCClass | DCDeclaration | DCField | DCKeyword | DCPackerInterface | DCParameter | DCSwitch | DCTypedef | EaseInBlendType | EaseInOutBlendType | EaseOutBlendType | HideInterval | LerpBlendType | NoBlendType | ShowInterval | WaitInterval): bool {.importcpp: "(# != nullptr)".}
func `==`*(x: CConstrainHprInterval | CConstrainPosHprInterval | CConstrainPosInterval | CConstrainTransformInterval | CConstraintInterval | CInterval | CIntervalManager | CLerpAnimEffectInterval | CLerpInterval | CLerpNodePathInterval | CMetaInterval | CMotionTrail | DCArrayParameter | DCAtomicField | DCClass | DCDeclaration | DCField | DCKeyword | DCPackerInterface | DCParameter | DCSwitch | DCTypedef | EaseInBlendType | EaseInOutBlendType | EaseOutBlendType | HideInterval | LerpBlendType | NoBlendType | ShowInterval | WaitInterval, y: type(nil)): bool {.importcpp: "(# == nullptr)".}

