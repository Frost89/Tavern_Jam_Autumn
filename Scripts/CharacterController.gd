extends CharacterBody2D
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

#Game Manager variables
var game_end = false
 
@export var speed = 500 #increased speed - mango - bet
@export var jump_velocity = -800 #increased jump - mango - bet
@export var gravity = 2000 #increased gravity - mango - bet

#Referencing Instances/Nodes
@onready var chargebar = $ChargeBar
@onready var timer = $Timer #Researching Timer and implementing it
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

#CHARGE-VARS
var charge = 99.9
@export var drain_rate = 5
var charge_drain = false

func _init():
#	print("Press F to start charge drain.")
	print("Press E to simulate hit.")
#INIT


func _ready():
	chargebar.value = charge
	timer.wait_time = 2.0
	timer.start(2.0)


func _process(delta): #Use for logical and systemic shi	
	if Input.is_action_just_pressed("SimHit") and not game_end: #Conditions will change once attacks are implemented
		print("You got hit.")
		update_hitsim()
	
	check_game_end()


func _physics_process(delta): #Use for physics based shi e.g velocity, force, impulse, etc
	var horizontal_direction = Input.get_axis("Left", "Right")
	movement(delta, horizontal_direction)
	update_anims(horizontal_direction)
	
func update_anims(h_dir):
	if h_dir != 0:
		sprite.flip_h = (h_dir == -1)
	
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
	charge += 10
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
