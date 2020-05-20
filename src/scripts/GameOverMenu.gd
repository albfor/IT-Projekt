extends Node

func _ready():
	$GUILayer/GUIGameOver.show()
	pause_mode = Node.PAUSE_MODE_PROCESS
	$GUILayer.layer = 99
	get_tree().paused

func _on_EndGameButton_pressed():
	get_tree().quit()

func set_score(score_red, score_blue):
	$GUILayer/GUIGameOver/GameOverMenu/Header/CenterScore/Score.set_text(str(score_blue) + " - " + str(score_red))
	Network.end_game()
