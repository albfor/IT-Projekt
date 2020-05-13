extends Node

var attack_commenced = false
var attack

var computers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Network.connect("attack_selected", self, "_on_attack")
	Network.connect("computer_selected", self, "_computer_selected")

func _on_attack(attack_type):
	attack_commenced = true
	attack = attack_type

# Don't allow other systems to attack same system att the same time
remote func _computer_selected(id):
	if not computers.has(id):
		computers.append(id)
	if (attack_commenced):
		print("player attacked computer: " + str(id) + " with " +  str(attack))
	
