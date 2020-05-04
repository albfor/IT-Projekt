extends Node

func _ready():
	$GameOverMenu.hide()
	pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$GameOverMenu.visible = !$GameOverMenu.visible
		get_tree().paused = !get_tree().paused
		

func _on_EndGameButton_pressed():
	get_tree().quit()
