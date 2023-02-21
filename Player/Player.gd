extends KinematicBody2D

const UP_Direction := Vector2.UP

onready var default_shape: CollisionShape2D = $DefaultShape
onready var crouch_shape : CollisionShape2D = $CrouchShape

onready var interaction_label: Label = $MainCamera/InteractionLabel
onready var page: Node2D = $MainCamera/Page

export var speed := 600.0
export var jump_strength := 1000.0
export var max_jumps := 2
export var double_jump_strength := 1200.0
export var gravity := 4500.0
export var slide_max := 30
var slide_velocity := 1

export var is_attacking1 := false
export var is_attacking2 := false

var _jump_made := 0
var _velocity := Vector2.ZERO

onready var sprite : AnimatedSprite = $AnimatedSprite

onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_crouching := false

var direction
var is_falling
var is_jumping
var is_double_jumping
var is_jump_cancelled
var is_idling
var is_running
var is_sliding

export var attacking_count := 0

onready var life := $Life

func _ready():
	for area in get_tree().get_nodes_in_group("crouch_areas"):
		area.connect("body_entered", self, "on_crouch_area_entered")
		area.connect("body_exited", self, "on_crouch_area_exited")
	var __
	__ = Events.connect("can_interact", self, "set_can_interact")
	life.life = 10000000
	play_animation("Idle")
	interaction_label.visible = false


func is_attacking():
	return attacking_count > 0

func play_animation(name: String):
	if name == "Attack1" or name == "Attack2":
		animation_player.play(name)
		return
	sprite.play(name)

func _physics_process(delta: float) -> void:
	if page.visible:
		return
	var _horizontal_direction = (
		Input.get_action_raw_strength("right")
		- Input.get_action_raw_strength("left")
	)
	if life.life == 0:
		play_animation("Death")
		queue_free()
	_velocity.x = _horizontal_direction * speed	
	_velocity.y += gravity * delta 
	
	is_falling = _velocity.y > 0.0 and not is_on_floor()
	is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	is_double_jumping = Input.is_action_just_pressed("jump") and is_falling
	is_jump_cancelled = Input.is_action_just_released("jump") and _velocity.y < 0.0 
	is_idling = is_on_floor() and is_zero_approx(_velocity.x)
	is_running = is_on_floor() and not is_zero_approx(_velocity.x)
	is_sliding = slide_velocity > 1

	if is_jumping:
		_jump_made += 1
		_velocity.y = -jump_strength
	if is_idling:
		_jump_made = 0
	elif is_running:
		_jump_made = 0
		if is_sliding_begin():
			slide_velocity = slide_max

	elif is_double_jumping:
		_jump_made += 1
		if _jump_made < max_jumps:
			_velocity.y = -double_jump_strength
	elif is_jump_cancelled:
		_velocity.y = 0.0


	_velocity.x += slide_velocity
	
	
	if is_sliding:
		if slide_velocity - 1 > 1:
			slide_velocity -= 1
		else: 
			slide_velocity = 1
	
	if Input.is_action_just_pressed("attack"):
		pass	

	if _horizontal_direction > 0:
		sprite.flip_h = false
	elif _horizontal_direction < 0:
		sprite.flip_h = true
			
	if attacking_count > 0:
		_velocity.x *= 0.5
		_velocity.y *= 0.8
		
		_velocity = move_and_slide(_velocity, UP_Direction)

		return
	
	_velocity = move_and_slide(_velocity, UP_Direction)

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
		set_crouching_shape()
		return true
	return false

func on_crouch_area_entered(body: Node):
	if body.name == "Player":
		set_crouching_shape()
		is_crouching = true


func on_crouch_area_exited(body:Node):
	if body.name == "Player":
		set_default_shape()
		is_crouching = false

func set_crouching_shape():
	default_shape.call_deferred("set", "disabled", true)
	crouch_shape.call_deferred("set", "disabled", false)

func set_default_shape():
	default_shape.call_deferred("set", "disabled", false)
	crouch_shape.call_deferred("set", "disabled", true)
	
func _on_Props_body_entered(_body:Node):
	var __ = get_tree().change_scene("res://Chapters/House.tscn")

func set_can_interact(value: bool):
	interaction_label.visible = value
