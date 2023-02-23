extends Area2D

var can_interact := false

export var scene_path :String = ""

func _ready():
	var __
	__ = connect("body_entered", self, "set_can_interact", [true])
	__ = connect("body_exited", self, "set_can_interact", [false])

func _process(_delta):
	if not can_interact:
		return
	if Input.is_action_just_pressed("collect"):
		if Quests.can_travel(name):
			if get_tree().change_scene(scene_path) != OK:
				print("Error changing scene: ", name)
		else:
			Events.emit_signal("dialogued", ["I can't go right now!"], "09" )

func set_can_interact(body: Node, value: bool):
	if body.name == "Player":
		can_interact = value
		Events.emit_signal("can_interact", value )
