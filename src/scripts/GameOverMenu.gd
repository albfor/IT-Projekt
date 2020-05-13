extends Node

func _ready():
	$GUILayer/GUIGameOver.show()
	pause_mode = Node.PAUSE_MODE_PROCESS
	$GUILayer.layer = 99
	get_tree().paused

func _on_EndGameButton_pressed():
	get_tree().quit()
