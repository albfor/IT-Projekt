extends Control

func _ready():
	$CanvasLayer/ActionMenu.hide()

func _on_Attack_1_pressed():
	if is_network_master():
		Network.red_attack_selected("attack_1")

func _on_Attack_2_pressed():
	if is_network_master():
		Network.red_attack_selected("attack_2")
