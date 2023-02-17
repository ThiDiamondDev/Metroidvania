extends Area2D

var can_interact := false
export var text_name :String = ""

func _ready():
	var __
	__ = connect("body_entered", self, "set_can_interact", [true])
	__ = connect("body_exited", self, "set_can_interact", [false])

func _process(_delta):
	if not can_interact:
		return
	if Input.is_action_just_pressed("collect") and text_name in all_texts:
		Events.emit_signal("found_file", {"name": text_name, "text": all_texts[text_name]} )

func set_can_interact(body: Node, value: bool):
	if body.name == "Player":
		can_interact = value
		Events.emit_signal("can_interact", value )

var lorem = "[fill]"\
 		+"The search for the cure is hard, but while we're running in circles " \
		+ "triyng to find the right elixir, the exploration leads to amazing texts.\n" \
		+ "Especifically one made me a lot curious. A paper describing something called" \
		+ "script. No idea what it really means. But the following text certainly hide " \
		+ "a powerfull meaning: Lorem Ipsum Dolor Siamet." \
		+ "[/fill]"

var potion_list := "[fill]1 - Aquum\n2 - Borum\n3 - Liquum\n" \
	+ "Attention to monsters!!!\n Bring the potion.[/fill]" 

var all_texts := {"lorem": lorem, "potion_list": potion_list}