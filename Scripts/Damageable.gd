extends Node
class_name Damageable

@export var health = 100

func hit(damage: int):
	health -= damage
	print(health)
	var parent = get_parent()
	parent.current_state = parent.states.HURT
	if health <=0:
		parent.current_state = parent.states.DEATH
		parent.queue_free()
