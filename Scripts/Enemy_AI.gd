extends CharacterBody2D

#state params
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var player_detection = $PlayerDetectionArea/CollisionShape2D
@onready var attack_range = $AttackRange/CollisionShape2D
@onready var hitbox = $HitBox/CollisionShape2D
@onready var timer = $CombatTimer

var player_ref
@onready var Player = get_tree().get_root().find_child("Proto", true, false)
var player_in_range = false
var direction = 0

@export var can_attack = false

@export var attack_interval = 2.0
@export var max_speed = 500
@export var speed = 0 #increased speed - mango - bet
@export var jump_velocity = 1000 #increased jump - mango - bet
@export var gravity = 2000 #increased gravity - mango - bet

enum states{
	IDLE,
	CHASE,
	ATTACK,
	HURT,
	DEATH
}
var current_state = states.IDLE
var states_list = []

func _ready():
	hitbox.disabled = true
	timer.wait_time = attack_interval
	timer.one_shot = true
#	Player = get_tree().get_root().find_child("Proto", true, false)
func _process(delta):
	handle_states()
	handle_flipping()
	if player_ref:
		current_state = states.CHASE
	else:
		current_state = states.IDLE
	
	if player_in_range and timer.is_stopped():
		can_attack = true
		current_state = states.ATTACK
		
		
	
func _physics_process(delta):
	velocity.y = 5000 if velocity.y > 5000 else (velocity.y + (gravity*delta))
	velocity.x = direction * speed
	move_and_slide()
	
	
func handle_flipping():
	if player_ref:
		direction = sign((player_ref.global_position.x - global_position.x))
		
	if direction <0 and !current_state==states.ATTACK:
		sprite.flip_h = false
	elif direction > 0 and !current_state==states.ATTACK:
		sprite.flip_h = true
		

func handle_states():
	match current_state:
		states.IDLE:
			sprite.modulate = Color.WHITE
			ap.play("Idle")
			speed = 0
		states.CHASE:
			sprite.modulate = Color.WHITE
			speed = max_speed
			pass
		states.ATTACK:
			sprite.modulate = Color.WHITE
			if can_attack:
				speed = 0
				ap.play("Attack1")
			timer.wait_time = attack_interval
			timer.start()
			
			can_attack = false
			current_state = states.IDLE
		states.HURT:
			sprite.modulate = Color.RED
		states.DEATH:
			print("Samurai is dead.")

func take_damage():
	current_state = states.HURT


func _on_player_detection_area_body_entered(body):
	if body == Player:
		print("Found Player" + body.name)
		player_ref = body


func _on_player_detection_area_body_exited(body):
	if body == Player:
		print("Player Lost " + body.name)
		player_ref = null
		hitbox.disabled = true
		

func _on_attack_range_body_entered(body):
	if body == Player:
		player_in_range = true


func _on_attack_range_body_exited(body):
	if body == Player:
		player_in_range = false
		hitbox.disabled = true


func _on_hit_box_body_entered(body):
	if body == Player and !hitbox.disabled:
		Player.take_damage()


func _on_combat_timer_timeout():
	can_attack = player_in_range

