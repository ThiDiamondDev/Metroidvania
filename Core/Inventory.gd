extends Node

signal item_added(item_name)
signal item_used(item_name)

var current_player : KinematicBody2D
var items := {
    "healing_potion": 0
}

var life := 100

func _process(_delta):
    if Input.is_action_just_pressed("heal"):
        use_item("healing_potion")

func add_item(item_name: String):
    if items.has(item_name):
        items[item_name] += 1
        emit_signal("item_added", item_name)


func use_item(item_name: String):
    if items.has(item_name) and items[item_name] > 0:
        items[item_name] -= 1
        emit_signal("item_used", item_name)
        