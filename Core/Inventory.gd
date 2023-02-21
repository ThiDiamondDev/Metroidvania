extends Node

signal item_added(args)

var items := {
    "healing_potion": 0
}

func add_item(item_name: String):
    if items.has(item_name):
        items[item_name] += 1
        emit_signal("item_added", item_name)