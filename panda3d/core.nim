{.passL: "-lpandaexpress -lpanda -lp3dtoolconfig -lp3dtool".}

type
  std_string {.importcpp: "std::string", header: "string".} = object

proc c_str*(self: std_string): cstring {.importcpp: "const_cast<char*>(#.c_str())".}

proc `$`*(s: std_string): string {.noinit.} =
  result = $(s.c_str())

type
  TypeHandle* {.importcpp: "TypeHandle", header: "typeHandle.h".} = object

proc is_derived_from*(this: TypeHandle, other: TypeHandle): TypeHandle {.importcpp: "#->is_derived_from(@)".}
proc name*(this: TypeHandle): std_string {.importcpp: "get_name".}
proc `$`*(this: TypeHandle): string =
  result = $(this.name)

type
  TypedObject* {.importcpp: "TypedObject *", header: "typedObject.h", inheritable, pure, bycopy.} = object

proc type*(this: TypedObject): TypeHandle {.importcpp: "#->get_type()".}
proc class_type*(_: typedesc[TypedObject]): TypeHandle {.importcpp: "TypedObject::get_class_type()".}
proc dcast*(_: typedesc[TypedObject], obj: TypedObject): TypedObject {.importcpp: "DCAST(TypedObject, @)".}

proc is_of_type*(this: TypedObject, other: TypeHandle): bool {.importcpp: "(#)->is_of_type(@)".}
template is_of_type*(this: TypedObject, T: typedesc): bool =
  this.is_of_type(T.class_type)

type
  TypedWritable* {.importcpp: "TypedWritable *", header: "typedWritable.h", inheritable, pure, bycopy.} = object of TypedObject

proc class_type*(_: typedesc[TypedWritable]): TypeHandle {.importcpp: "TypedWritable::get_class_type()".}
proc dcast*(_: typedesc[TypedWritable], obj: TypedObject): TypedWritable {.importcpp: "DCAST(TypedWritable, @)".}

type
  ReferenceCount* {.importcpp: "PT(ReferenceCount)", header: "referenceCount.h", inheritable, pure, bycopy.} = object

proc `==`*(x: ReferenceCount, y: type(nil)): bool {.importcpp: "#.is_null()".}
proc ref_count*(this: ReferenceCount): int {.importcpp: "#->get_ref_count()".}

type
  TypedReferenceCount* {.importcpp: "PT(TypedReferenceCount)", header: "typedReferenceCount.h", inheritable, pure, bycopy.} = object of TypedObject

proc class_type*(_: typedesc[TypedReferenceCount]): TypeHandle {.importcpp: "TypedReferenceCount::get_class_type()".}
proc dcast*(_: typedesc[TypedReferenceCount], obj: TypedObject): TypedReferenceCount {.importcpp: "DCAST(TypedReferenceCount, @)".}
proc `==`*(x: TypedReferenceCount, y: type(nil)): bool {.importcpp: "#.is_null()".}
proc ref_count*(this: TypedReferenceCount): int {.importcpp: "#->get_ref_count()".}

type
  TypedWritableReferenceCount* {.importcpp: "PT(TypedWritableReferenceCount)", header: "typedWritableReferenceCount.h", inheritable, pure, bycopy.} = object of TypedWritable

proc class_type*(_: typedesc[TypedWritableReferenceCount]): TypeHandle {.importcpp: "TypedWritableReferenceCount::get_class_type()".}
proc dcast*(_: typedesc[TypedWritableReferenceCount], obj: TypedObject): TypedWritableReferenceCount {.importcpp: "DCAST(TypedWritableReferenceCount, @)".}
proc `==`*(x: TypedWritableReferenceCount, y: type(nil)): bool {.importcpp: "#.is_null()".}
proc ref_count*(this: TypedWritableReferenceCount): int {.importcpp: "#->get_ref_count()".}

type
  AsyncTask* {.importcpp: "PT(AsyncTask)", header: "asyncTask.h", inheritable, pure, bycopy.} = object of TypedReferenceCount

proc class_type*(_: typedesc[AsyncTask]): TypeHandle {.importcpp: "AsyncTask::get_class_type()".}
proc dcast*(_: typedesc[AsyncTask], obj: TypedObject): AsyncTask {.importcpp: "DCAST(AsyncTask, @)".}
proc time*(this: AsyncTask): float {.importcpp: "#->get_elapsed_time()".}

type
  AsyncTaskManager* {.importcpp: "PT(AsyncTaskManager)", header: "asyncTaskManager.h", inheritable, pure, bycopy.} = object of TypedReferenceCount

proc get_global_ptr*(_: typedesc[AsyncTaskManager]): AsyncTaskManager {.importcpp: "AsyncTaskManager::get_global_ptr()".}
proc add*(this: AsyncTaskManager, task: AsyncTask) {.importcpp: "#->add(@)".}
proc poll*(this: AsyncTaskManager) {.importcpp: "#->poll()".}

type
  PandaNode* {.importcpp: "PT(PandaNode)", header: "pandaNode.h", inheritable, pure, bycopy.} = object of TypedWritableReferenceCount

proc class_type*(_: typedesc[PandaNode]): TypeHandle {.importcpp: "PandaNode::get_class_type()".}
proc dcast*(_: typedesc[PandaNode], obj: TypedObject): PandaNode {.importcpp: "DCAST(PandaNode, @)".}
proc newPandaNode*(name: cstring): PandaNode {.constructor, importcpp: "new PandaNode(@)".}
proc get_name*(this: PandaNode): std_string {.importcpp: "#->get_name()".}
proc set_name*(this: PandaNode, name: cstring) {.importcpp: "#->set_name(@)".}

proc name*(this: PandaNode): std_string {.importcpp: "#->get_name()".}
proc `name=`*(this: PandaNode, name: cstring) {.importcpp: "#->set_name(@)".}

type
  NodePath* {.importcpp: "NodePath", header: "nodePath.h", inheritable, pure.} = object

proc constructNodePath*(): NodePath {.constructor, importcpp: "NodePath(@)".}
proc constructNodePath*(name: cstring): NodePath {.constructor, importcpp: "NodePath(@)".}
proc constructNodePath*(node: PandaNode): NodePath {.constructor, importcpp: "NodePath(@)".}

proc node*(this: NodePath): PandaNode {.importcpp: "node".}
proc ls*(this: NodePath) {.importcpp: "ls".}
proc find*(this: NodePath, path: cstring): NodePath {.importcpp: "find".}
proc attach_new_node*(this: NodePath, node: PandaNode) : NodePath {.importcpp: "attach_new_node".}
proc attach_new_node*(this: NodePath, name: cstring) : NodePath {.importcpp: "attach_new_node".}
proc reparent_to*(this: NodePath, other: NodePath) {.importcpp: "reparent_to".}
proc detach_node*(this: NodePath) {.importcpp: "detach_node".}
proc remove_node*(this: NodePath) {.importcpp: "remove_node".}
proc hide*(this: NodePath) {.importcpp: "hide".}
proc show*(this: NodePath) {.importcpp: "show".}
proc stash*(this: NodePath) {.importcpp: "stash".}
proc unstash*(this: NodePath) {.importcpp: "unstash".}
proc set_pos*(this: NodePath, x: float, y: float, z: float) {.importcpp: "set_pos".}
proc set_hpr*(this: NodePath, h: float, p: float, r: float) {.importcpp: "set_hpr".}
proc set_scale*(this: NodePath, scale: float) {.importcpp: "set_scale".}
proc set_scale*(this: NodePath, sx: float, sy: float, sz: float) {.importcpp: "set_scale".}

type
  Lens* {.importcpp: "PT(Lens)", header: "lens.h", inheritable, pure, bycopy.} = object of PandaNode

proc class_type*(_: typedesc[Lens]): TypeHandle {.importcpp: "Lens::get_class_type()".}
proc dcast*(_: typedesc[Lens], obj: TypedObject): Lens {.importcpp: "DCAST(Lens, @)".}
proc aspect_ratio*(this: Lens): float {.importcpp: "#->get_aspect_ratio()".}
proc `aspect_ratio=`*(this: Lens, aspectRatio: float) {.importcpp: "#->set_aspect_ratio(@)".}

type
  Camera* {.importcpp: "PT(Camera)", header: "camera.h", inheritable, pure, bycopy.} = object of PandaNode

proc class_type*(_: typedesc[Camera]): TypeHandle {.importcpp: "Camera::get_class_type()".}
proc dcast*(_: typedesc[Camera], obj: TypedObject): Camera {.importcpp: "DCAST(Camera, @)".}
proc newCamera*(name: cstring): Camera {.constructor, importcpp: "new Camera(@)".}
proc active*(this: Camera): bool {.importcpp: "#->is_active()".}
proc `active=`*(this: Camera, active: bool) {.importcpp: "#->set_active(@)".}
proc get_lens*(this: Camera): Lens {.importcpp: "#->get_lens()".}

type
  Light* {.importcpp: "PT(Light)", header: "lightNode.h", inheritable, pure, bycopy.} = object

proc class_type*(_: typedesc[Light]): TypeHandle {.importcpp: "Light::get_class_type()".}
proc dcast*(_: typedesc[Light], obj: TypedObject): Light {.importcpp: "DCAST(Light, @)".}

type
  LightNode* {.importcpp: "PT(LightNode)", header: "lightNode.h".} = object of PandaNode

proc class_type*(_: typedesc[LightNode]): TypeHandle {.importcpp: "LightNode::get_class_type()".}
proc dcast*(_: typedesc[LightNode], obj: TypedObject): LightNode {.importcpp: "DCAST(LightNode, @)".}
proc upcastToPandaNode*(node: LightNode): PandaNode {.importcpp: "@".}
proc upcastToLight*(node: LightNode): Light {.importcpp: "@".}

type
  AmbientLight* {.importcpp: "PT(AmbientLight)", header: "ambientLight.h".} = object of LightNode

proc class_type*(_: typedesc[AmbientLight]): TypeHandle {.importcpp: "AmbientLight::get_class_type()".}
proc dcast*(_: typedesc[AmbientLight], obj: TypedObject): AmbientLight {.importcpp: "DCAST(AmbientLight, @)".}
proc newAmbientLight*(name: cstring): AmbientLight {.constructor, importcpp: "new AmbientLight(@)".}

type
  Loader* {.importcpp: "PT(Loader)", header: "loader.h", inheritable, pure, bycopy.} = object of TypedReferenceCount

proc class_type*(_: typedesc[Loader]): TypeHandle {.importcpp: "Loader::get_class_type()", header: "loader.h".}
proc dcast*(_: typedesc[Loader], obj: TypedObject): Loader {.importcpp: "DCAST(Loader, @)".}
proc newLoader*(name: cstring = "loader"): Loader {.constructor, importcpp: "new Loader(@)".}
proc get_global_ptr*(_: typedesc[Loader]): Loader {.importcpp: "Loader::get_global_ptr()", header: "loader.h".}
proc load_sync*(this: Loader, filename: cstring): PandaNode {.importcpp: "#->load_sync(@)".}

type
  DisplayRegion* {.importcpp: "PT(DisplayRegion)", header: "displayRegion.h", inheritable, pure, bycopy.} = object of TypedReferenceCount

proc class_type*(_: typedesc[DisplayRegion]): TypeHandle {.importcpp: "DisplayRegion::get_class_type()".}
proc dcast*(_: typedesc[DisplayRegion], obj: TypedObject): DisplayRegion {.importcpp: "DCAST(DisplayRegion, @)".}
proc set_camera*(this: DisplayRegion, camera: NodePath) {.importcpp: "#->set_camera(@)".}

type
  FrameBufferProperties* {.importcpp: "FrameBufferProperties", header: "frameBufferProperties.h".} = object

proc get_default*(_: typedesc[FrameBufferProperties]): FrameBufferProperties {.importcpp: "FrameBufferProperties::get_default()", header: "frameBufferProperties.h".}

type
  WindowProperties* {.importcpp: "WindowProperties", header: "windowProperties.h".} = object

proc get_default*(_: typedesc[WindowProperties]): WindowProperties {.importcpp: "WindowProperties::get_default()", header: "windowProperties.h".}
proc open*(this: WindowProperties): bool {.importcpp: "get_open".}

type
  GraphicsOutput* {.importcpp: "PT(GraphicsOutput)", header: "graphicsOutput.h", inheritable, pure, bycopy.} = object of TypedWritableReferenceCount

proc class_type*(_: typedesc[GraphicsOutput]): TypeHandle {.importcpp: "GraphicsOutput::get_class_type()".}
proc dcast*(_: typedesc[GraphicsOutput], obj: TypedObject): GraphicsOutput {.importcpp: "DCAST(GraphicsOutput, @)".}
proc make_display_region*(this: GraphicsOutput): DisplayRegion {.importcpp: "#->make_display_region(@)".}
proc make_display_region*(this: GraphicsOutput, l: float, r: float, b: float, t: float): DisplayRegion {.importcpp: "#->make_display_region(@)".}
proc make_mono_display_region*(this: GraphicsOutput): DisplayRegion {.importcpp: "#->make_mono_display_region(@)".}
proc make_mono_display_region*(this: GraphicsOutput, l: float, r: float, b: float, t: float): DisplayRegion {.importcpp: "#->make_mono_display_region(@)".}
proc make_stereo_display_region*(this: GraphicsOutput): DisplayRegion {.importcpp: "#->make_stereo_display_region(@)".}
proc make_stereo_display_region*(this: GraphicsOutput, l: float, r: float, b: float, t: float): DisplayRegion {.importcpp: "#->make_stereo_display_region(@)".}
proc get_sbs_left_x_size*(this: GraphicsOutput): float {.importcpp: "#->get_sbs_left_x_size()".}
proc get_sbs_left_y_size*(this: GraphicsOutput): float {.importcpp: "#->get_sbs_left_y_size()".}
proc get_sbs_right_x_size*(this: GraphicsOutput): float {.importcpp: "#->get_sbs_right_x_size()".}
proc get_sbs_right_y_size*(this: GraphicsOutput): float {.importcpp: "#->get_sbs_right_y_size()".}

type
  GraphicsBuffer* {.importcpp: "PT(GraphicsBuffer)", header: "graphicsBuffer.h", inheritable, pure, bycopy.} = object of GraphicsOutput

proc class_type*(_: typedesc[GraphicsBuffer]): TypeHandle {.importcpp: "GraphicsBuffer::get_class_type()".}
proc dcast*(_: typedesc[GraphicsBuffer], obj: TypedObject): GraphicsBuffer {.importcpp: "DCAST(GraphicsBuffer, @)".}

type
  GraphicsWindow* {.importcpp: "PT(GraphicsWindow)", header: "graphicsWindow.h", inheritable, pure, bycopy.} = object of GraphicsOutput

proc class_type*(_: typedesc[GraphicsWindow]): TypeHandle {.importcpp: "GraphicsWindow::get_class_type()".}
proc dcast*(_: typedesc[GraphicsWindow], obj: TypedObject): GraphicsWindow {.importcpp: "DCAST(GraphicsWindow, @)".}
proc get_properties*(this: GraphicsWindow): WindowProperties {.importcpp: "#->get_properties()".}

type
  GraphicsPipe* {.importcpp: "PT(GraphicsPipe)", header: "graphicsPipe.h", inheritable, pure, bycopy.} = object of TypedReferenceCount

proc class_type*(_: typedesc[GraphicsPipe]): TypeHandle {.importcpp: "GraphicsPipe::get_class_type()".}
proc dcast*(_: typedesc[GraphicsPipe], obj: TypedObject): GraphicsPipe {.importcpp: "DCAST(GraphicsPipe, @)".}

type
  GraphicsPipeSelection* {.importcpp: "GraphicsPipeSelection*", header: "graphicsPipeSelection.h", inheritable, pure, bycopy.} = object

proc get_global_ptr*(_: typedesc[GraphicsPipeSelection]): GraphicsPipeSelection {.importcpp: "GraphicsPipeSelection::get_global_ptr()", header: "graphicsPipeSelection.h".}
proc print_pipe_types*(this: GraphicsPipeSelection) {.importcpp: "#->print_pipe_types()".}
proc make_default_pipe*(this: GraphicsPipeSelection) : GraphicsPipe {.importcpp: "#->make_default_pipe(@)".}

type
  GraphicsEngine* {.importcpp: "PT(GraphicsEngine)", header: "graphicsEngine.h", inheritable, pure, bycopy.} = object of ReferenceCount

proc get_global_ptr*(_: typedesc[GraphicsEngine]): GraphicsEngine {.importcpp: "GraphicsEngine::get_global_ptr()", header: "graphicsEngine.h".}
proc open_windows*(this: GraphicsEngine) {.importcpp: "#->open_windows()".}
proc render_frame*(this: GraphicsEngine) {.importcpp: "#->render_frame()".}
proc make_output*(this: GraphicsEngine, pipe: GraphicsPipe, name: cstring, sort: int, fb_prop: FrameBufferProperties, win_prop: WindowProperties, flags: int) : GraphicsOutput {.importcpp: "#->make_output(@)".}

type
  Event* {.importcpp: "CPT_Event", header: "event.h", inheritable, pure, bycopy.} = object of TypedReferenceCount

proc nameInternal(this: Event): cstring {.importcpp: "#->get_name().c_str()".}
proc name*(this: Event): string = $(this.nameInternal)

type
  EventHandler* {.importcpp: "EventHandler*", header: "eventHandler.h", inheritable, pure, bycopy.} = object of TypedObject

proc get_global_event_handler*(_: typedesc[EventHandler]): EventHandler {.importcpp: "EventHandler::get_global_event_handler()", header: "eventHandler.h".}

type
  EventQueue* {.importcpp: "EventQueue*", header: "eventQueue.h", inheritable, pure, bycopy.} = object

proc newEventQueue*(): EventQueue {.constructor, importcpp: "new EventQueue(@)".}
proc queue_event*(this: EventQueue, event: Event) {.importcpp: "#->queue_event(@)".}
proc clear*(this: EventQueue) {.importcpp: "#->clear(@)".}
proc is_queue_empty*(this: EventQueue): bool {.importcpp: "#->is_queue_empty(@)".}
proc is_queue_full*(this: EventQueue): bool {.importcpp: "#->is_queue_full(@)".}
proc dequeue_event*(this: EventQueue): Event {.importcpp: "#->dequeue_event(@)".}
proc get_global_event_queue*(_: typedesc[EventQueue]): EventQueue {.importcpp: "EventQueue::get_global_event_queue()", header: "eventQueue.h".}
