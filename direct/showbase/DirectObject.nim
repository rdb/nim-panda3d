import ./Messenger
import ./MessengerGlobal

export Messenger.DirectObject

proc accept*(this: DirectObject, event: string, function: proc ()) =
  messenger.accept(event, this, function)

proc accept*[T](this: DirectObject, event: string, function: proc (param: T)) =
  messenger.accept(event, this, function)

proc ignore*(this: DirectObject, event: string) =
  messenger.ignore(event, this)

proc ignoreAll*(this: DirectObject) =
  messenger.ignoreAll(this)
