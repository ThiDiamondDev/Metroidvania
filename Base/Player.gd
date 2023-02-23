extends "res://Base/BaseEntity.gd"

onready var interaction_label: Label = $MainCamera/InteractionLabel
onready var page: Node2D = $MainCamera/Page

onready var lifebar = $MainCamera/LifeBar

export var max_jumps := 2
export var slide_max := 30
var slide_velocity := 1


var _jump_made := 0
var is_sliding

func _ready():
	var __
	__ = Events.connect("player_damage", self, "damage" )
	__ = Inventory.connect("item_used", self, "heal")

	for area in get_tree().get_nodes_in_group("crouch_areas"):
		area.connect("body_entered", self, "on_crouch_area_entered")
		area.connect("body_exited", self, "on_crouch_area_exited")
	
	__ = Events.connect("can_interact", self, "set_can_interact")
	__ = sprite.connect("animation_finished", self, "on_animation_finished")
	
	lifebar.init(Inventory.life)

	Inventory.current_player = self
	play_animation("Idle")
	interaction_label.visible = false

func damage(value):
	Inventory.life = lifebar.damage(value)

func heal(name):
	Inventory.life = lifebar.heal(name)
	
func on_animation_finished():
	if sprite.animation == "Attack1":
		attacking_count = 0

func is_attacking():
	return attacking_count > 0

func play_animation(name: String):
	sprite.play(name)

func _physics_process(delta: float) -> void:
	if page.visible:
		return
	var _horizontal_direction = (
		Input.get_action_raw_strength("right")
		- Input.get_action_raw_strength("left")
	)
	velocity.x = _horizontal_direction * speed	
	velocity.y += gravity * delta 
	
	update_physics_states()
	
	is_sliding = slide_velocity > 1

	if is_jumping:
		_jump_made += 1
		velocity.y = -jump_strength
	if is_idling:
		_jump_made = 0
	elif is_running:
		_jump_made = 0
		if is_sliding_begin():
			slide_velocity = slide_max

	elif is_double_jumping:
		_jump_made += 1
		if _jump_made < max_jumps:
			velocity.y = -double_jump_strength
	elif is_jump_cancelled:
		velocity.y = 0.0


	velocity.x += slide_velocity
	
	
	if is_sliding:
		if slide_velocity - 1 > 1:
			slide_velocity -= 1
		else: 
			slide_velocity = 1
	
	if Input.is_action_just_pressed("attack"):
		attacking_count = 1
		play_animation("Attack1")	

	if _horizontal_direction > 0:
		sprite.flip_h = false
	elif _horizontal_direction < 0:
		sprite.flip_h = true
			
	if attacking_count > 0:
		velocity.x *= 0.5
		velocity.y *= 0.8
		
		velocity = move_and_slide(velocity, UP_Direction)

		return
	
	velocity = move_and_slide(velocity, UP_Direction)

	if (is_crouching and not is_sliding):
		if is_idling:
			play_animation("CrouchIdle")	
		else:
			play_animation("CrouchWalk")
	elif is_idling:
		play_animation("Idle")
	
	elif is_running:
		if is_sliding:
			play_animation("Slide")
		
		else :
			play_animation("Run")

	elif is_jumping:
		play_animation("Jump")
		
	elif is_falling and not is_sliding:
		play_animation("Fall")
	
func is_sliding_begin():
	if is_crouching or is_sliding:
		return false
	if Input.is_action_just_pressed("down") and	is_running:
		return true
	return false

func on_crouch_area_entered(body: Node):
	if body.name == "Player":
		is_crouching = true


func on_crouch_area_exited(body:Node):
	if body.name == "Player":
		is_crouching = false

	

func set_can_interact(value: bool):
	interaction_label.visible = value
