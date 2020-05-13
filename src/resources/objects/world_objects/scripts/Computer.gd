extends Area2D

onready var currently_on
signal computer_entered()

func _process(delta):
	# Updates the TimeDisplay
	if $TimerDisplay.is_visible_in_tree():
		$TimerDisplay/TimerTimeLeft.set_text(str(int($Timer.get_time_left() + 1)))
	if $TimerDisplayRed.is_visible_in_tree():
		$TimerDisplayRed/TimerTimeLeft.set_text(str(int($TimerRed.get_time_left() + 1)))

func _physics_process(delta):
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

func _ready():
	
	Network.connect("attack_started", self, "start_attack_timer")
	$TimerDisplay.hide()
	$TimerDisplayRed.hide()
	$TimerRed.set_one_shot(true)
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


# Sends the id of the computer if someone clicks on it
func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		var id = self.get_instance_id()
		Network.computer_selected(id)


remote func start_attack_timer(id):
	if (id == self.get_instance_id()):
		$TimerDisplayRed.show()
		$TimerRed.start(5)


func _on_TimerRed_timeout():
	$TimerDisplayRed.hide()
	Network.attack_timer(self.get_instance_id(), "finished")
