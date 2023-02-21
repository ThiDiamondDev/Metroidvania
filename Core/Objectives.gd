extends Label

func _ready():
	text = Quests.current_objective
	var __
	__ = Events.connect("update_objective", self, "update_objective")

func update_objective(objective: String):
	text = objective