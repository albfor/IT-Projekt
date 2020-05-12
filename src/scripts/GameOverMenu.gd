extends Node

func _ready():
	$GUIGameOver.hide()
	pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$GUIGameOver.visible = !$GUIGameOver.visible
		get_tree().paused = !get_tree().paused
		

func _on_EndGameButton_pressed():
	get_tree().quit()
