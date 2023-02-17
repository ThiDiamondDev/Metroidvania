extends Node2D

onready var text_label : RichTextLabel = $RichTextLabel
onready var close_button : Button  = $Button
onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_file  := {"text": "", "name": ""}
func _ready():
	visible = false
	var __
	__ = Events.connect("found_file",self, "on_found_file")
	__ = close_button.connect("pressed", self, "close_text_box")

func on_found_file(file):
	current_file = file
	text_label.bbcode_text = file.text
	visible = true
	animation_player.play("show_text")

func close_text_box():
	visible = false
	Events.emit_signal("file_closed", current_file.name)
