extends CharacterBody2D

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

@export var speed = 300
@export var jump_velocity = -500
@export var gravity = 1000

func _physics_process(delta):
	#Add gravity first
	velocity.y += gravity * delta
	
	#X-axis movement
	velocity.x = Input.get_axis("Left", "Right") * speed
	move_and_slide()
	
	#Jumping 
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	
