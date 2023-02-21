extends Node

var  current_objective : String
var potions_count :=  0

var file_found := {"potion_list": false, "lorem" : false}
var potions_found := 0
var forest_2_can_travel := false


func _ready():
    update_objective("Find the alchemist")
    var __
    __ = Events.connect("collected", self, "on_item_collected")
    __ = Events.connect("dialog_finished", self, "on_dialog_finished")
    __ = Events.connect("file_closed", self, "on_file_closed")

func can_travel(portal_name):
    match portal_name:
        "Forest1Portal": return potions_found == 3        
        "Forest2Portal": return forest_2_can_travel    


func update_potions_quest():
    update_objective("Find the potions %d/3" % potions_found )
    
func on_item_collected(item: String):
    if item == "potion":
        if potions_found < 3:
            potions_found += 1
            update_potions_quest()
        
        if potions_found == 3:
            update_objective("Meet the alchemist again")
            
func on_dialog_finished(name: String):
    if name == "01" and not file_found["potion_list"]:
        update_objective("Find the potion list")

    if name == "03":
        Inventory.add_item("healing_potion")
        update_objective("Use the potion!")
        
func on_file_closed(file_name):
    
    if not file_found[file_name]:
        if file_name == "potion_list":
            forest_2_can_travel = true	
        file_found[file_name] = true
        update_objective("Find the potions %d/3" % potions_found )
        
func update_objective(objective: String):
    current_objective = objective
    Events.emit_signal("update_objective", objective )