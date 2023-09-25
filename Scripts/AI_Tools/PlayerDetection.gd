extends CharacterBody2D

@export var speed = 500 #increased speed - mango - bet
@export var jump_velocity = 1000 #increased jump - mango - bet
@export var gravity = 2000 #increased gravity - mango - bet

@onready var los = $PlayerDetectionRayCast2D

var player
var has_seen_player
var last_seen_player_pos: Vector2
var reached_last_pos: bool = true

func _ready():
	player =get_tree().get_root().find_child("Proto", true, false)
	
func find_player():
	if player:
		los.look_at(player.global_position)
		has_seen_player = is_player_in_los()
		if has_seen_player:
			print("player spotted")
		else:
			print("Idle bitch")

func is_player_in_los():
	if los.get_collider() == player:
		last_seen_player_pos = player.global_position
		reached_last_pos = false
		return true
	reached_last_pos = true
	return false
	

func _physics_process(delta):
	find_player()
