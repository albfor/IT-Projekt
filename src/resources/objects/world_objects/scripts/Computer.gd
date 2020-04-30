extends Area2D

# If player presses "enter_computer" while overlapping with a computer
# Swap scene 
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if (body.get_class() == "Player" and body.is_network_master() and Input.is_action_just_pressed("enter_computer")):
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
	add_to_group("computers")
