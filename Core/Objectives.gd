extends Label

var  current_objective := "Find the alchemist"

var objective_index := 0
var potions_count   :=  0


func _ready():
	update_objective("Find the alchemist.")
	var __
	__ = Events.connect("collected", self, "on_item_collected")
	__ = Events.connect("dialog_finished", self, "on_dialog_finished")
	__ = Events.connect("update_objective", self, "update_objective")
	__ = Events.connect("file_closed", self, "on_file_closed")

func update_objective(objective: String):
	text = objective
	objective_index += 1

func update_potions_quest():
	Events.emit_signal("update_objective", "Find the potions %d/3" % Events.potions_found )

func on_item_collected(item: String):
	if item == "potion" and Events.potions_found < 3:
		Events.potions_found += 1
		print(Events.potions_found, item)
		update_potions_quest()
		
	
func on_dialog_finished():
	if not Events.file_found.has("potion_list"):
		update_potions_quest()
	else:
		update_potions_quest()


func on_file_closed(file_name):
	Events.file_found[file_name] = true
	if objective_index == 2:	
		Events.emit_signal("update_objective", "Find the potions %d/3" % Events.potions_found )