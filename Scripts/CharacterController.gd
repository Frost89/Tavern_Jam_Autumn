extends CharacterBody2D
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

#Game Manager variables
var game_end = false
var jump_max = 2
var jump_count = 0
@export var is_hit = false
@export var is_attacking = false
@export var can_damage = false
@export var damage: int = 15 


@export var speed = 750 #increased speed - mango - bet
@export var jump_velocity = 1500 #increased jump - mango - bet
@export var gravity = 2000 #increased gravity - mango - bet

#Referencing Instances/Nodes
@onready var chargebar = $ChargeBar
@onready var timer = $Timer #Researching Timer and implementing it
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var combat_timer = $CombatTimer
@onready var hitbox = $HitArea

#CHARGE-VARS
var charge = 50
@export var drain_rate = 5
@export var damge_absorbed = 10
var charge_drain = false

func _init():
	print("Press E to attack - punch.")
	print("Press F to simulate hit.")
#INIT


func _ready():
	hitbox.monitoring = false
	chargebar.value = charge
	timer.wait_time = 2.0
	timer.start(2.0)
	combat_timer.one_shot = true


func _process(delta): #Use for logical and systemic shi	
#	if Input.is_action_just_pressed("SimHit") and not game_end: #Conditions will change once attacks are implemented
#		take_damage()
	if Input.is_action_just_pressed("Punch") and not game_end and combat_timer.is_stopped():
		attack()
	
	check_game_end()


func attack():
	is_attacking = true
#	combat_timer.wait_time = 0.3
#	combat_timer.start()
#	print("You are punching.")
	anim_player.play("Punch")
	print("Attack")
	
	
func take_damage():
	combat_timer.wait_time = 0.3
	combat_timer.start()
	is_hit = true
#	print("You got hit.")
	update_hitsim()

func debug():
	print("Stuck")


func _physics_process(delta): #Use for physics based shi e.g velocity, force, impulse, etc
	var horizontal_direction = Input.get_axis("Left", "Right")
	movement(delta, horizontal_direction)
	update_anims(horizontal_direction)
	if  !anim_player.is_playing():
		anim_player.play("Idle")
	
	
func update_anims(h_dir):
	if h_dir != 0:
		sprite.flip_h = (h_dir == -1)
		hitbox.scale.x = abs(hitbox.scale.x) * h_dir
	
	if is_hit and !combat_timer.is_stopped():
		if velocity.y != 0:
			anim_player.play("OnAirDamage")
			print("OnAirDamage")
		else:
			anim_player.play("GroundDamage")
			print("GroundDamage")
		is_hit = false
	
	if !is_attacking and combat_timer.is_stopped():
		if is_on_floor():
			if h_dir == 0:
				anim_player.play("Idle")
#				print("Idle")
			else:
				anim_player.play("Run")
#				print("Run")
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
	if !is_attacking:
		move_and_slide()
	
	#Reset jump_count:
	if is_on_floor() and jump_count!=0 :
		jump_count = 0
	
	#Jumping 
	if Input.is_action_just_pressed("Jump") and jump_count<jump_max:
		velocity.y = -jump_velocity
		jump_count += 1
		
	
	
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


func _on_hit_area_body_entered(body):
	if can_damage:
		for child in body.get_children():
			if child is Damageable:
				child.hit(damage)
