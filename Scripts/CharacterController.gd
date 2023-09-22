extends CharacterBody2D
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

#Game Manager variables
var game_end = false
var is_hit = false
 
@export var speed = 500 #increased speed - mango - bet
@export var jump_velocity = -800 #increased jump - mango - bet
@export var gravity = 2000 #increased gravity - mango - bet

#Referencing Instances/Nodes
@onready var chargebar = $ChargeBar
@onready var timer = $Timer #Researching Timer and implementing it
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var combat_timer = $CombatTimer

#CHARGE-VARS
var charge = 90
@export var drain_rate = 5
@export var damge_absorbed = 10
var charge_drain = false

func _init():
	print("Press E to attack - punch.")
	print("Press F to simulate hit.")
#INIT


func _ready():
	chargebar.value = charge
	timer.wait_time = 2.0
	timer.start(2.0)
	combat_timer.one_shot = true


func _process(delta): #Use for logical and systemic shi	
	if Input.is_action_just_pressed("SimHit") and not game_end: #Conditions will change once attacks are implemented
		take_damage()
	if Input.is_action_just_pressed("Punch") and not game_end:
		attack()
	
	check_game_end()


func attack():
	combat_timer.wait_time = 0.3
	combat_timer.start()
	print("You are punching.")
	anim_player.play("Punch")
	
func take_damage():
	combat_timer.wait_time = 0.3
	combat_timer.start()
	is_hit = true
	print("You got hit.")
	update_hitsim()


func _physics_process(delta): #Use for physics based shi e.g velocity, force, impulse, etc
	var horizontal_direction = Input.get_axis("Left", "Right")
	movement(delta, horizontal_direction)
	update_anims(horizontal_direction)
	
func update_anims(h_dir):
	if h_dir != 0:
		sprite.flip_h = (h_dir == -1)
	
	if is_hit:
		if velocity.y != 0:
			anim_player.play("OnAirDamage")
		else:
			anim_player.play("GroundDamage")
		is_hit = false
	
	if combat_timer.is_stopped():
		if is_on_floor():
			if h_dir == 0:
				anim_player.play("Idle")
			else:
				anim_player.play("Run")
		else:
			if velocity.y < 0:
				anim_player.play("Jump")
			elif velocity.y > 0:
				anim_player.play("Fall")

func update_charge():
	charge -= drain_rate
	chargebar.value = charge
	if charge < 0:
		charge = 0


func update_hitsim():
	charge += damge_absorbed
	chargebar.value = charge
	if charge > 100:
		charge = 100
		

func movement(delta, h_dir):
	#Add gravity first
	if !is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 5000:
			velocity.y = 5000
	
	#X-axis movement
	velocity.x = h_dir * speed
	if combat_timer.is_stopped():
		move_and_slide()
	
	#Jumping 
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	
	
func check_game_end():
	if not game_end:
		if charge == 0:
			print("You're fully discharged. *windowsshutdownsound.jpg*")
			game_end = true
		
		if charge == 100:
			print("You're overcharged. BOOM!")
			game_end = true


func _on_timer_timeout():
	charge_drain = true
	if charge_drain and not game_end:
		update_charge()
