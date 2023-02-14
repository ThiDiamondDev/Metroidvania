extends KinematicBody2D

const UP_Direction := Vector2.UP

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D

onready var focus_area : Area2D = get_parent()

var random := RandomNumberGenerator.new()
var velocity := Vector2.ZERO
var gravity  := 4500.0

var is_moving := false
var idle_counter := 300
var counter := 0

export var speed := 300.0

enum states  {
	IDLE,RUN
} 
var state = states.IDLE
var is_running : bool

var direction := 1 
var player_focus = false
var player: KinematicBody2D
var is_attacking = false

onready var life := $Life

func _ready():
	var __
	__ = focus_area.connect("body_entered", self, "_on_FocusArea_body_entered")
	__ = focus_area.connect("body_exited", self, "_on_FocusArea_body_exited")
	
	
	randomize_counter()

func flip():
	direction *= -1
	velocity.x = 0
	counter = 0
func randomize_counter():
	counter = random.randi_range(100,300)
	

func idle() :
	sprite.play("Idle")
		
func run():
	if not is_running:
		velocity.x = direction * speed
	
	if direction == 1:
		sprite.flip_h = false
	else: 
		sprite.flip_h = true
	
	sprite.play("Run")


func passive_movement() -> void:
	random.randomize()
	is_running = is_on_floor() and not is_zero_approx(velocity.x)
	
	if counter > 0 :
		counter -= 1
			
	if counter == 0:
		randomize_counter()
		if state == states.IDLE:
			state = states.RUN
			run()
		else:
			state = states.IDLE
			idle()
	if velocity.x > 0:
		velocity.x -= 1
	elif velocity.x < 0:
		velocity.x += 1
				
	
func _physics_process(delta: float) -> void:
	if life.life == 0:
		sprite.play("Death")
		queue_free()

	if not player_focus:
		passive_movement()
	
	else:
		if is_instance_valid(player):
			direction = int(sign(player.position.x - position.x))
		if is_attacking:
			sprite.play("Attack")
		else:
			velocity.x = direction * speed
			run()
		
	velocity.y = delta * gravity
	velocity = move_and_slide(velocity, UP_Direction)

	if is_attacking:
		if player != null:
			if player.is_attacking():
				life.damage(2)
			player.life.damage(1)
	
func _on_Area2D_body_exited(body:Node):
	if body.name == "Player":
		is_attacking = false 

func _on_Area2D_body_entered(body:Node):
	if body.name == "Player":
		is_attacking = true


func _on_FocusArea_body_entered(body:Node):
	if body.name == "Player":
		player_focus = true
		player = body
	

func _on_FocusArea_body_exited(body:Node):
	if body.name == "Rat":
		flip()
