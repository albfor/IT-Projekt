extends Area2D


func _physics_process(delta):
	# Entering and exiting computers 
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if (body.is_in_group("players") and body.is_network_master() and Input.is_action_just_pressed("enter_computer")):
			# If inside a computer exit on "enter_computer"
			# else enter computer
			if $Desktop.is_visible_in_tree():
				exit_computer(body)
			else:
				enter_computer(body)

func _ready():
	add_to_group("computers")
	# Decides which img will be used as the texture for each computer
	var pc1 = preload("res://src/resources/images/Desk 1.png")
	var pc2 = preload("res://src/resources/images/Desk 2.png")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(1,2)
	if (my_random_number == 1):
		$Sprite.set_texture(pc1)
	else:
		$Sprite.set_texture(pc2)

# Player exiting a computer
func exit_computer(var body):
	$Desktop.hide()
	body.set_camera()
	# Enable Player movement again
	body.enable_movement()
	var players = get_tree().get_nodes_in_group("players")
	#Show players
	for player in players:
		player.show()
	#Show computers
	var computers = get_tree().get_nodes_in_group("computers")
	for computer in computers: 
		computer.get_node("Sprite").show()

# Player entering a computer
func enter_computer(var body):
	$Desktop.show()
	# Change to desktop camera
	$Desktop/Camera2D.make_current()
	# Can't have players moving around while inside os
	body.disable_movement()
	# Hides all players 
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.hide()
	#Hides all computers
	var computers = get_tree().get_nodes_in_group("computers")
	for computer in computers: 
		computer.get_node("Sprite").hide()
