extends KinematicBody2D

const UP_Direction := Vector2.UP

onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var sprite : AnimatedSprite = $AnimatedSprite


export var gravity := 4500.0
export var speed := 600.0
export var jump_strength := 1000.0
export var double_jump_strength := 1200.0

var velocity := Vector2.ZERO

var is_crouching := false

var direction
var is_falling
var is_jumping
var is_double_jumping
var is_jump_cancelled
var is_idling
var is_running

var attacking_count := 0

func update_physics_states():
    is_falling = velocity.y > 0.0 and not is_on_floor()
    is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
    is_double_jumping = Input.is_action_just_pressed("jump") and is_falling
    is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0.0 
    is_idling = is_on_floor() and is_zero_approx(velocity.x)
    is_running = is_on_floor() and not is_zero_approx(velocity.x)
    