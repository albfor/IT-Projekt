extends Node2D

# Hides the role selection in the beginning
func _ready():
	$RoleSelection.hide()
	
# On click show available roles
# TODO: Set player to blue team
func _on_blue_team_button_up():
	$red_team.set_disabled(true)
	$blue_team.hide()
	$BlueSelect.hide()
	$RedSelect.hide()
	$RoleSelection.show()

# Just removes the scene on for now 
# TODO: Set player to redteam
func _on_red_team_button_up():
	queue_free()
	start_game()

# Print selected role into console and deletes scene
# TODO: Set player to role
func _on_ItemList_item_selected(index):
	print('Role ' + $RoleSelection/ItemList.get_item_text(index) + ' selected.')
	queue_free()
	start_game()

func start_game():
	Network.begin_game()
