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
	"Great!!!",
	"Now you can use the healing potion and survive."
]
func _init():
	var __
	__ = connect("body_entered",self, "on_body_entered")
	__ = connect("body_exited",self, "on_body_exited")
	
func _process(_delta):
	if Input.is_action_just_pressed("collect") and can_interact:
		if not Quests.file_found["potion_list"]:
			Events.emit_signal("dialogued", dialog1 ,"01")
		else:
			if Quests.potions_found < 3:
				Events.emit_signal("dialogued", dialog2 ,"02" )
				Quests.forest_2_can_travel = true
			else:
				Events.emit_signal("dialogued", dialog3,"03" )


func on_body_exited(body:Node):
    if body.name == "Player":
        can_interact = false
func on_body_entered(body:Node):
    if body.name == "Player":
        can_interact = true
