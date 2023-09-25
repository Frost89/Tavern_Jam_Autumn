extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Sandbox_scene_A.tscn")


func _on_instructions_pressed():
	get_tree().change_scene_to_file("res://Scenes/instructions.tscn")


func _on_quit_pressed():
	get_tree().quit()
