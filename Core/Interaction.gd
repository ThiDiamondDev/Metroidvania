extends Area2D

var can_interact := false
var dialog1 := [
#	"Alchemist: Hello soldier, thanks to come here.",
#	"The situation is not good.",
#	"While these poor people is diyng, they are spreading the plague to everywhere.",
	"Go to the library beside and find the potion list I need."
]
var dialog2 := [
#	"I need it right now!!!",
	"Where are the potions?"
]

var dialog3 := [
	"Well done!! You finished the game!!!"
]
func _init():
	var __
	__ = connect("body_entered",self, "on_body_entered")
	__ = connect("body_exited",self, "on_body_exited")
	
func _process(_delta):
	if Input.is_action_just_pressed("collect") and can_interact:
		if not Events.file_found.has("potion_list"):
			Events.emit_signal("dialogued", dialog1 )
		else:
			if Events.potions_found < 3:
				Events.emit_signal("dialogued", dialog2 )
			else:
				Events.emit_signal("dialogued", dialog3 )
func on_body_exited(body:Node):
    if body.name == "Player":
        can_interact = false
func on_body_entered(body:Node):
    if body.name == "Player":
        can_interact = true
