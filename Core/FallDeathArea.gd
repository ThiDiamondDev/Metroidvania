extends Area2D


func _ready():
	var __
	__ = connect("body_entered", self, "on_body_entered")
	

func on_body_entered(body: Node):
	body.queue_free()