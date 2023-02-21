extends Node

signal collected(item)
signal interacted(args)
signal dialogued(args)
signal can_interact(args)
signal found_file(args)
signal dialog_finished(name)
signal update_objective(args)
signal file_closed(args)

# Remove signal never emitted warning
func emit_signals():
    if false:
        emit_signal("collected", "")
        emit_signal("interacted", "")
        emit_signal("dialogued", "")
        emit_signal("can_interact", "")
        emit_signal("found_file", "")
        emit_signal("dialog_finished","")
        emit_signal("update_objective","")
        emit_signal("file_closed","")


