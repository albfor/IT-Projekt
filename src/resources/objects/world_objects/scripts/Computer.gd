extends Area2D


func _physics_process(delta):
	# Entering and exiting computers 
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if (body.is_in_group("players") and body.is_network_master() and Input.is_action_just_pressed("enter_computer")):
			if $Desktop.is_visible_in_tree():
				$Desktop.hide()
				body.set_camera()
				body.enable_movement()
				var players = get_tree().get_nodes_in_group("players")
				for player in players:
					player.show()
				var computers = get_tree().get_nodes_in_group("computers")
				for computer in computers: 
					computer.get_node("Sprite").show()
			else:
				$Desktop.show()
				$Desktop/Camera2D.make_current()
				body.disable_movement()
				var players = get_tree().get_nodes_in_group("players")
				for player in players:
					player.hide()
				var computers = get_tree().get_nodes_in_group("computers")
				for computer in computers: 
					computer.get_node("Sprite").hide()

func _ready():
	print("computer " + str(position))
	add_to_group("computers")
	# Decides which img will be used as the texture
	var pc1 = preload("res://src/resources/images/Desk 1.png")
	var pc2 = preload("res://src/resources/images/Desk 2.png")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(1,2)
	if (my_random_number == 1):
		$Sprite.set_texture(pc1)
	else:
		$Sprite.set_texture(pc2)
	
