extends Node

func _ready():
	$GUILayer/GUIGameOver.hide()
	pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		# Sets the Game over screen on the top, 
		# this needs to change if additional gui 
		# elements are added. This is ugly too and need to change
		if($GUILayer.layer < 2):
			$GUILayer.layer = 2
			$GUILayer/GUIGameOver.visible = !$GUILayer/GUIGameOver.visible
			get_tree().paused = !get_tree().paused
		else:
			$GUILayer.layer = 0
			$GUILayer/GUIGameOver.visible = !$GUILayer/GUIGameOver.visible
			get_tree().paused = !get_tree().paused

func _on_EndGameButton_pressed():
	get_tree().quit()
