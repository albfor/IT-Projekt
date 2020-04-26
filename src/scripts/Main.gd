extends Control

func _on_HostGameButton_pressed():
	get_tree().change_scene("res://src/scenes/Host_game.tscn")

func _on_JoinGameButton_pressed():
	get_tree().change_scene("res://src/scenes/Join_game.tscn")
