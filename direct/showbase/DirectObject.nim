import ./Messenger
import ./MessengerGlobal

export Messenger.DirectObject

proc accept*(this: DirectObject, event: string, function: proc ()) =
  messenger.accept(event, this, function)
