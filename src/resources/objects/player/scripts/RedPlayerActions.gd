extends Control

func _ready():
	$CanvasLayer/ActionMenu.hide()

func _on_Attack_1_pressed():
	Network.red_attack("attack_1")

func _on_Attack_2_pressed():
	Network.red_attack("attack_2")
