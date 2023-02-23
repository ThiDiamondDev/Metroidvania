extends "res://Base/BaseEntity.gd"

onready var timer : Timer = $Timer

var random := RandomNumberGenerator.new()

var is_moving := false
var idle_counter := 300
var counter := 0

enum states  {
	IDLE,RUN
} 
var state = states.IDLE

var player_focus = false
var player: KinematicBody2D
var is_attacking = false

onready var damage_area : Area2D = $DamageArea

var can_damage := false

var damage_timer_on := false

func _ready():
	$Timer.one_shot = true
	var __
	
	__ = damage_area.connect("body_entered", self, "set_can_damage", [true])
	__ = damage_area.connect("body_exited", self, "set_can_damage", [false])

	randomize_counter()

func set_can_damage(body: Node, value: bool):
	if body.name == "Player":
		can_damage = value

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
	if $ProgressBar.value == 0:
		queue_free()

	if not is_instance_valid(Inventory.current_player):
		return
	
	if Inventory.current_player.position.x  > position.x:
		direction = 1
	else:
		direction = -1

		
	if can_damage:
		if Inventory.current_player.is_attacking():
			$ProgressBar.damage(1)
		velocity.x = 0
		sprite.play("Attack")
		if timer.is_stopped():
			timer.start(0)
			Events.emit_signal("player_damage", 10)
	else:
		velocity.x = direction * speed
		run()
	
	
	velocity.y += delta * gravity
	velocity = move_and_slide(velocity, UP_Direction)


