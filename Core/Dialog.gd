extends Control

var dialog_list := ["oiii", "Hello i am a test", "Helllo worlddddd"]

onready var animation_plyer: AnimationPlayer = $AnimationPlayer
onready var label : RichTextLabel = $Label

var dialog_id: String

func _ready():
	label.percent_visible = 0
	var __  
	__ = animation_plyer.connect("animation_finished", self, "on_animation_finished")
	__ = Events.connect("dialogued", self, "play_dialog")
	
func set_next_text():
	if  dialog_list.size() > 0:
		label.bbcode_text =  get_current_text()
		animation_plyer.play("dialog")
	else:
		Events.emit_signal("dialog_finished", dialog_id)
	
func get_current_text():
	return "\n[center]" + dialog_list[0] + "[/center]"

func on_animation_finished(_animation_name):
	label.percent_visible = 0
	dialog_list.pop_front() 	
	set_next_text()

func play_dialog(dialog: Array, id: String):
	dialog_list = dialog
	dialog_id = id
	set_next_text()
