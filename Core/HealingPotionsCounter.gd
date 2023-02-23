extends Node2D

onready var label: Label = $CounterLabel

func _ready():
	visible = false
	var __ 
	__ = Inventory.connect("item_added", self, "update_counter")
	__ = Inventory.connect("item_used", self, "update_counter")

func update_counter(item_name: String):
	if item_name == "healing_potion":
		if not visible:
			visible = true	
		label.text = get_counter_string()

func get_counter_string() -> String:
	return String(Inventory.items["healing_potion"]) + "X - (E) use"