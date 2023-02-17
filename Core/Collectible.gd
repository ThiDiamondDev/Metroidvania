extends Area2D

var can_collect := false
export var collectible_name: String = "key"
func _process(_delta):
    if Input.is_action_just_pressed("collect") and can_collect:
        Events.emit_signal("collected", collectible_name)
        queue_free()

func _on_CollectibleArea_body_exited(body:Node):
    if body.name == "Player":
        can_collect = false
func _on_CollectibleArea_body_entered(body:Node):
    if body.name == "Player":
        can_collect = true
