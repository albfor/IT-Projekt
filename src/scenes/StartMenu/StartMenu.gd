extends Node2D

var players_ready = []

signal player_added(team_side)

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
	add_teams("red")

# Print selected role into console and deletes scene
# TODO: Set player to role
func _on_ItemList_item_selected(index):
	print('Role ' + $RoleSelection/ItemList.get_item_text(index) + ' selected.')
	add_teams("blue")

func start_game():
	Network.begin_game()

remotesync func add_teams(team_side):
	var id = get_tree().get_network_unique_id()
	if not get_tree().is_network_server():
		rpc_id(1, "add_to_team", team_side, id)
	else:
		add_to_team(team_side, id)

remotesync func add_to_team(team_side, id):
	if team_side == "blue":
		Network.set_players_blue(id)
	if team_side == "red":
		Network.set_players_red(id)
	if Network.all_ready():
		start_game()
