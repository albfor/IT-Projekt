extends Area2D

# If player presses "enter_computer" while overlapping with a computer
# Swap scene 
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_class() == "Player" and Input.is_action_just_pressed("enter_computer"):
			get_tree().change_scene("res://src/scenes/Main.tscn") #TODO: change path to OS scene once implemented
