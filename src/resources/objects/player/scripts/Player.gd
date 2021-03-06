extends Actor

puppet var player_pos = Vector2()
puppet var player_motion = Vector2()
var movements_allowed = true;

func _physics_process(_delta):
	#Needed for online
	if is_network_master():
		var direction: = get_direction()
		velocity = calculate_move_velocity(velocity, direction, speed)
		#Important for updating player movement for other clients
		rset("player_motion", velocity)
		rset("player_pos", position)
	else:
		position = player_pos
		velocity = player_motion
	
	if movements_allowed:
		velocity = move_and_slide(velocity, FLOOR_NORMAL)

	if not is_network_master():
		player_pos = position # To avoid jitter
	

# Calculates the movement/fall speed
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2, 
		speed: Vector2
	) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	# If jumping overrule y axis velocity
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity

# Returns the direction of user input for the player movement
# Key bindings for move_right, move_left and jump can be changed 
# in Project -> Project settings -> Input Map
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

#Sets the name of the player
func set_player_name(new_name):
	get_node("NameLabel").set_text(new_name)

# Show label saying "press e to enter" when on a PC
func _on_Area2D_area_entered(area):
	if area.is_in_group("computers"):
		$Label.show()

func _on_Area2D_area_exited(area):
	$Label.hide()

func _ready():
	add_to_group("players")
	player_pos = position
	if is_network_master():
		$CameraWorld.current = true

func set_camera():
	$CameraWorld.make_current()

func enable_movement():
	movements_allowed = true

func disable_movement():
	movements_allowed = false
