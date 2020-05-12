extends Area2D

onready var currently_on

func _process(delta):
	# Updates the TimeDisplay
	if $TimerDisplay.is_visible_in_tree():
		$TimerDisplay/TimerTimeLeft.set_text(str(int($Timer.get_time_left() + 1)))
	

func _physics_process(delta):
	# Entering and exiting computers 
<<<<<<< HEAD
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if (body.is_in_group("players") and body.is_network_master() and Input.is_action_just_pressed("enter_computer")):
			# If inside a computer exit on "enter_computer"
			# else enter computer
			if $Desktop.is_visible_in_tree():
				exit_computer(body)
			else:
				enter_computer(body)
=======
	if currently_on == null:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if (body.is_in_group("players") and body.is_network_master() and Input.is_action_just_pressed("enter_computer")):
				if currently_on == null:
					currently_on = body
					enter_computer()
				else:
					exit_computer()
					currently_on = null
>>>>>>> os

func _ready():
	$TimerDisplay.hide()
	$Timer.set_one_shot(true) 
	currently_on = null
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

<<<<<<< HEAD
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
=======
func enter_computer():
	$Desktop.show()
	$Desktop/Camera2D.make_current()
	currently_on.disable_movement()
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.hide()
	var computers = get_tree().get_nodes_in_group("computers")
	for computer in computers: 
		computer.get_node("Sprite").hide()
		

func exit_computer():
	$Desktop.hide()
	currently_on.set_camera()
	currently_on.enable_movement()
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.show()
	var computers = get_tree().get_nodes_in_group("computers")
	for computer in computers: 
		computer.get_node("Sprite").show()

func _on_Desktop_password_changed():
	print("Password Change Started")
	$TimerDisplay.show()
	$Timer.start(5)
	exit_computer()


func _on_Desktop_project_started():
	print("Project Started")
	$TimerDisplay.show()
	$Timer.start(5)
	exit_computer()


func _on_Timer_timeout():
	print("Project Finished")
	$TimerDisplay.hide()
	currently_on = null
>>>>>>> os
