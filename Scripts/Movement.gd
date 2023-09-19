extends CharacterBody2D

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

@export var speed = 500 #increased speed - mango
@export var jump_velocity = -800 #increased jump - mango
@export var gravity = 2000 #increased gravity - mango

#CHARGE-VARS
var charge = 75
var drain_rate = 0.05
var charge_drain = false

func _init():
	print("Press F to start charge drain.")
	print("Press E to simulate hit.")
#INIT

var game_end = false


func _physics_process(delta):
	#Add gravity first
	velocity.y += gravity * delta
	
	#X-axis movement
	velocity.x = Input.get_axis("Left", "Right") * speed
	move_and_slide()
	
	#Jumping 
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
		
	
	#Charge/Discharge - mango
	var chargebar = $ChargeBar
	chargebar.value = charge
	
	
	if Input.is_action_just_pressed("Drain"):
		print("Drain Activated")
		charge_drain = true
	
	if charge_drain == true:
		if game_end == false:
			update_charge()
	
	if Input.is_action_just_pressed("SimHit"):
		print("You got hit.")
		if game_end == false:
			update_hitsim()
	
	if game_end == false:
		if charge == 0:
			print("You're fully discharged. *windowsshutdownsound.jpg*")
			game_end = true
		
		
		if charge == 100:
			print("You're overcharged. BOOM!")
			game_end = true
	
	
	
func update_charge():
	charge -= drain_rate
	if charge < 0:
		charge = 0


func update_hitsim():
	charge += 10
	if charge > 100:
		charge = 100
	
	
