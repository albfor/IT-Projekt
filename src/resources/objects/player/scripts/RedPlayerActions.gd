extends Control

signal red_attack_1()
signal red_attack_2()

func _ready():
	$CanvasLayer/ActionMenu.hide()


func _on_Attack_1_pressed():
	emit_signal("red_attack_1")


func _on_Attack_2_pressed():
	emit_signal("red_attack_2")
