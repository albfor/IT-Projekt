extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	Network.connect("attack_made", self, "_on_attack")
	Network.connect("computer_selected", self, "_computer_selected")

func _on_attack(attack_type):
	print(attack_type)

remote func _computer_selected(id):
	print(id)
