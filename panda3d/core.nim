{.passL: "-lpandaexpress -lpanda -lp3dtoolconfig -lp3dtool"}

type
  std_string {.importcpp: "std::string", header: "string".} = object

proc c_str*(self: std_string): cstring {.importcpp: "const_cast<char*>(#.c_str())".}

proc `$`*(s: std_string): string {.noinit.} =
  result = $(s.c_str())

type
  TypedObject* {.importcpp: "PT(TypedObject)", header: "typedObject.h", inheritable} = object

type
  TypedReferenceCount* {.importcpp: "PT(TypedReferenceCount)", header: "typedReferenceCount.h", inheritable} = object

proc `==`*(x: TypedReferenceCount, y: type(nil)): bool {.importcpp: "#.is_null()"}

type
  TypedWritableReferenceCount* {.importcpp: "PT(TypedWritableReferenceCount)", header: "typedWritableReferenceCount.h", inheritable} = object

proc `==`*(x: TypedWritableReferenceCount, y: type(nil)): bool {.importcpp: "#.is_null()"}

type
  AsyncTask* {.importcpp: "PT(AsyncTask)", header: "asyncTask.h", inheritable} = object of TypedReferenceCount

type
  AsyncTaskManager* {.importcpp: "PT(AsyncTaskManager)", header: "asyncTaskManager.h", inheritable} = object of TypedReferenceCount

proc get_global_ptr*(_: typedesc[AsyncTaskManager]): AsyncTaskManager {.cdecl, importcpp: "AsyncTaskManager::get_global_ptr()"}
proc add*(this: AsyncTaskManager, task: AsyncTask) {.cdecl, importcpp: "#->add(@)"}
proc poll*(this: AsyncTaskManager) {.cdecl, importcpp: "#->poll()"}

type
  PandaNode* {.importcpp: "PT(PandaNode)", header: "pandaNode.h", inheritable} = object of TypedWritableReferenceCount

proc newPandaNode*(name: cstring): PandaNode {.cdecl, constructor, importcpp: "new PandaNode(@)"}
proc get_name*(this: PandaNode): std_string {.cdecl, importcpp: "#->get_name()"}

type
  NodePath* {.importcpp: "NodePath", header: "nodePath.h"} = object

proc constructNodePath*(): NodePath {.cdecl, constructor, importcpp: "NodePath(@)"}
proc constructNodePath*(name: cstring): NodePath {.cdecl, constructor, importcpp: "NodePath(@)"}
proc constructNodePath*(node: PandaNode): NodePath {.cdecl, constructor, importcpp: "NodePath(@)"}

proc ls*(this: NodePath) {.cdecl, importcpp: "ls"}
proc attach_new_node*(this: NodePath, node: PandaNode) : NodePath {.cdecl, importcpp: "attach_new_node"}
proc attach_new_node*(this: NodePath, name: cstring) : NodePath {.cdecl, importcpp: "attach_new_node"}
proc reparent_to*(this: NodePath, other: NodePath) {.cdecl, importcpp: "reparent_to"}
proc set_pos*(this: NodePath, x: float, y: float, z: float) {.cdecl, importcpp: "set_pos"}
proc set_hpr*(this: NodePath, h: float, p: float, r: float) {.cdecl, importcpp: "set_hpr"}
proc set_scale*(this: NodePath, x: float, y: float, z: float) {.cdecl, importcpp: "set_scale"}

type
  Camera* {.importcpp: "PT(Camera)", header: "camera.h", inheritable} = object of PandaNode

proc newCamera*(name: cstring): Camera {.cdecl, constructor, importcpp: "new Camera(@)"}

type
  Light* {.importcpp: "PT(Light)", header: "lightNode.h", inheritable} = object

type
  LightNode* {.importcpp: "PT(LightNode)", header: "lightNode.h"} = object of PandaNode

proc upcastToPandaNode*(node: LightNode): PandaNode {.cdecl, importcpp: "@"}
proc upcastToLight*(node: LightNode): Light {.cdecl, importcpp: "@"}

type
  AmbientLight* {.importcpp: "PT(AmbientLight)", header: "ambientLight.h"} = object of LightNode

proc newAmbientLight*(name: cstring): AmbientLight {.cdecl, constructor, importcpp: "new AmbientLight(@)"}

type
  Loader* {.importcpp: "PT(Loader)", header: "loader.h", inheritable} = object of TypedReferenceCount

proc newLoader*(name: cstring = "loader"): Loader {.cdecl, constructor, importcpp: "new Loader(@)"}
proc get_global_ptr*(_: typedesc[Loader]): Loader {.cdecl, importcpp: "Loader::get_global_ptr()"}
proc load_sync*(this: Loader, filename: cstring): PandaNode {.cdecl, importcpp: "#->load_sync(@)"}

type
  DisplayRegion* {.importcpp: "PT(DisplayRegion)", header: "displayRegion.h", inheritable} = object of TypedReferenceCount

proc set_camera*(this: DisplayRegion, camera: NodePath) {.cdecl, importcpp: "#->set_camera(@)"}

type
  GraphicsOutput* {.importcpp: "PT(GraphicsOutput)", header: "graphicsOutput.h", inheritable} = object of TypedWritableReferenceCount

proc make_display_region*(this: GraphicsOutput): DisplayRegion {.cdecl, importcpp: "#->make_display_region(@)"}
proc make_display_region*(this: GraphicsOutput, l: float, r: float, b: float, t: float): DisplayRegion {.cdecl, importcpp: "#->make_display_region(@)"}
proc make_mono_display_region*(this: GraphicsOutput): DisplayRegion {.cdecl, importcpp: "#->make_mono_display_region(@)"}
proc make_mono_display_region*(this: GraphicsOutput, l: float, r: float, b: float, t: float): DisplayRegion {.cdecl, importcpp: "#->make_mono_display_region(@)"}
proc make_stereo_display_region*(this: GraphicsOutput): DisplayRegion {.cdecl, importcpp: "#->make_stereo_display_region(@)"}
proc make_stereo_display_region*(this: GraphicsOutput, l: float, r: float, b: float, t: float): DisplayRegion {.cdecl, importcpp: "#->make_stereo_display_region(@)"}

type
  GraphicsBuffer* {.importcpp: "PT(GraphicsBuffer)", header: "graphicsBuffer.h"} = object of GraphicsOutput

type
  GraphicsWindow* {.importcpp: "PT(GraphicsWindow)", header: "graphicsWindow.h"} = object of GraphicsOutput

type
  GraphicsPipe* {.importcpp: "PT(GraphicsPipe)", header: "graphicsPipe.h", inheritable} = object of TypedReferenceCount

type
  GraphicsPipeSelection* {.importcpp: "GraphicsPipeSelection*", header: "graphicsPipeSelection.h", inheritable} = object

proc get_global_ptr*(_: typedesc[GraphicsPipeSelection]): GraphicsPipeSelection {.cdecl, importcpp: "GraphicsPipeSelection::get_global_ptr()"}
proc print_pipe_types*(this: GraphicsPipeSelection) {.cdecl, importcpp: "#->print_pipe_types()"}
proc make_default_pipe*(this: GraphicsPipeSelection) : GraphicsPipe {.cdecl, importcpp: "#->make_default_pipe(@)"}

type
  FrameBufferProperties* {.importcpp: "FrameBufferProperties", header: "frameBufferProperties.h"} = object

proc get_default*(_: typedesc[FrameBufferProperties]): FrameBufferProperties {.cdecl, importcpp: "FrameBufferProperties::get_default()"}

type
  WindowProperties* {.importcpp: "WindowProperties", header: "windowProperties.h"} = object

proc get_default*(_: typedesc[WindowProperties]): WindowProperties {.cdecl, importcpp: "WindowProperties::get_default()"}

type
  GraphicsEngine* {.importcpp: "PT(GraphicsEngine)", header: "graphicsEngine.h", inheritable} = object

proc get_global_ptr*(_: typedesc[GraphicsEngine]): GraphicsEngine {.cdecl, importcpp: "GraphicsEngine::get_global_ptr()"}
proc open_windows*(this: GraphicsEngine) {.cdecl, importcpp: "#->open_windows()"}
proc render_frame*(this: GraphicsEngine) {.cdecl, importcpp: "#->render_frame()"}
proc make_output*(this: GraphicsEngine, pipe: GraphicsPipe, name: cstring, sort: int, fb_prop: FrameBufferProperties, win_prop: WindowProperties, flags: int) : GraphicsOutput {.cdecl, importcpp: "#->make_output(@)"}
