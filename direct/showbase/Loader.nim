import ../../panda3d/core

type
  PandaLoader = Loader

type
  Loader* = ref object of RootObj
    sfxManager*: AudioManager
    musicManager*: AudioManager

proc loadModel*(this: Loader, modelPath: string, loaderOptions: LoaderOptions = LoaderOptions()): NodePath =
  var loader = PandaLoader.getGlobalPtr()
  return initNodePath(loader.loadSync(initFilename(modelPath), loaderOptions))

proc loadTexture*(this: Loader, texturePath: string): Texture =
  var texture = TexturePool.loadTexture(initFilename(texturePath))
  if texture == nil:
    var e: ref IOError
    new(e)
    e.msg = "Could not load texture: " & texturePath
    raise e
  return texture

proc loadSound*(this: Loader, manager: AudioManager, soundPath: string, positional: bool = false): AudioSound =
  return manager.getSound(initFilename(soundPath), positional, 0)

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
