import ../../panda3d/core

type
  Loader* = ref object of RootObj
    sfxManager*: AudioManager
    musicManager*: AudioManager

proc loadModel*(this: Loader, modelPath: string): NodePath =
  var loader = core.Loader.getGlobalPtr()
  return constructNodePath(loader.loadSync(modelPath))

proc loadSound*(this: Loader, manager: AudioManager, soundPath: string, positional: bool = false): AudioSound =
  return manager.getSound(soundPath, positional)

proc loadSfx*(this: Loader, soundPath: string, positional: bool = false): AudioSound =
  if this.sfxManager == nil:
    this.sfxManager = AudioManager.createAudioManager()
  return this.loadSound(this.sfxManager, soundPath, positional)

proc loadMusic*(this: Loader, soundPath: string, positional: bool = false): AudioSound =
  if this.musicManager == nil:
    this.musicManager = AudioManager.createAudioManager()
    this.musicManager.setConcurrentSoundLimit(1)
  return this.loadSound(this.musicManager, soundPath, positional)

var loader* = Loader()
