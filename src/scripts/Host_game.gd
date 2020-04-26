extends Control

func _on_StartGameButton_pressed():
	if($Menu/HBoxContainer/Buttons/AddName.text == ""):
		print("You need a name")
	else:
		get_tree().change_scene("res://src/scenes/Level.tscn")
	
