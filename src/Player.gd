extends Actor

func _physics_process(delta):
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FLOOR_NORMAL)

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



# Show label saying "press e to enter" when on a PC
func _on_Area2D_area_entered(area):
	print(area.get_name())
	$Label.show()

func _on_Area2D_area_exited(area):
	$Label.hide()
