extends Node

# To see if an attack has been selected
var attack_commenced = false
var attack

# To know which computer and how many times it has been attacked
var computerID = []
var counter = []
var computers = [[],[]]

# To know which computer is used for attacks
var active_computers = []

# Teams score
var red_score = 0
var blue_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Network.connect("attack_selected", self, "_on_attack")
	Network.connect("computer_selected", self, "_computer_selected")
	Network.connect("attack_finished", self, "_attack_succesful")


func _on_attack(attack_type):
	attack_commenced = true
	attack = attack_type

# Don't allow other systems to attack same system att the same time
func _computer_selected(id):
	# Can't use active computer
	if not active_computers.has(id):
		# If attack and computer selected attack it with selected attack
		if (attack_commenced && attack == "attack_1"):
			# Adds the computer to attacked list
			active_computers.append(id)
			# Remove this below if testing
			attack_commenced = false
			
			# If computer hasn't been attacked add it to the attack list
			if not computers[0].has(id):
				computers[0].append(id)
				computers[1].append(0)
			#check to see if attack was succesful
			Network.attack_timer(id, "start")
	else:
		print("this computer is already in use")

# Adds points if attack was succesful
func _attack_succesful(id):
	# Id to find the correct computer and how many times it has been attacked
	var find_id = (computers[0].find(id))
	active_computers.erase(id)
	counter = computers[1]
	counter[find_id] += 1
	computers[1] = counter
	if counter[find_id] >= 2:
		red_score += 1
		Network.add_event("Red team succesfully bruteforced a password", "red", 1)
		# Add the attack timer
		computers[0].erase(id)
		computers[1].remove(find_id)
		print("computer succesfully hacked")
		print(red_score)
		if red_score >= 5:
			#Add score to scoreboard
			end_score()
	counter = 0

func end_score():
	Network.end_score(red_score, blue_score)
