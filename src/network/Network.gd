extends Node

# Default game port. Can be any number between 1024 and 49151.
const DEFAULT_PORT = 10567

# Max number of players.
const MAX_PLAYERS = 5

# Default name for player
var player_name = "Player 1"

# Teams with team members
var players_red = []
var players_blue = []

# Names for remote players in id:name format.
var players = {}
var players_ready = []

# Signals to let lobby GUI know what's going on.
signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)

# actions made on the server from red team
signal attack_selected(attack_type)
signal computer_selected(id)
signal attack_started(id)
signal attack_finished(id)
signal attack_unsuccesful(id)

# Callback from SceneTree.
func _player_connected(id):
	# Registration of a client beings here, tell the connected player that we are here.
	rpc_id(id, "register_player", player_name)


# Callback from SceneTree.
func _player_disconnected(id):
	if has_node("res://src/scenes/Level.tscn"): # Game is in progress.
		if get_tree().is_network_server():
			emit_signal("game_error", "Player " + players[id] + " disconnected")
			end_game()
	else: # Game is not in progress.
		# Unregister this player.
		unregister_player(id)


# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	# We just connected to a server
	emit_signal("connection_succeeded")


# Callback from SceneTree, only for clients (not server).
func _server_disconnected():
	emit_signal("game_error", "Server disconnected")
	end_game()


# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")


# Lobby management functions.

remote func register_player(new_player_name):
	var id = get_tree().get_rpc_sender_id()
	players[id] = new_player_name
	emit_signal("player_list_changed")


func unregister_player(id):
	players.erase(id)
	emit_signal("player_list_changed")

remote func pre_start_game(spawn_points_blue, spawn_points_red):
	# Change scene.
	var world = load("res://src/scenes/Level.tscn").instance()

	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("StartMenu").hide()

	var player_scene_blue = preload("res://src/resources/objects/player/Player.tscn")
	var player_scene_red = preload("res://src/resources/objects/player/PlayerRed.tscn")
	
	for p_id in spawn_points_red:
		var spawn_pos = world.get_node("SpawnPoints_red/" + str(spawn_points_red[p_id])).position
		var player_red = player_scene_red.instance()
		
		player_red.set_name(str(p_id)) # Use unique ID as node name.
		player_red.position = spawn_pos
		player_red.set_network_master(p_id) #set unique id as master.
		
		world.get_node("Players").add_child(player_red)
		
	for p_id in spawn_points_blue:
		var spawn_pos = world.get_node("SpawnPoints_blue/" + str(spawn_points_blue[p_id])).position
		var player_blue = player_scene_blue.instance()

		player_blue.set_name(str(p_id)) # Use unique ID as node name.
		player_blue.position = spawn_pos
		player_blue.set_network_master(p_id) #set unique id as master.
		
		if p_id == get_tree().get_network_unique_id():
			# If node for this peer id, set name.
			player_blue.set_player_name(player_name)
		else:
			# Otherwise set name from peer.
			player_blue.set_player_name(players[p_id])
		world.get_node("Players").add_child(player_blue)

	if not get_tree().is_network_server():
		# Tell server we are ready to start.
		rpc_id(1, "ready_to_start", get_tree().get_network_unique_id())
	elif players.size() != 0:
		post_start_game()


remote func post_start_game():
	get_tree().set_pause(false) # Unpause and unleash the game!


remote func ready_to_start(id):
	assert(get_tree().is_network_server())

	if not id in players_ready:
		players_ready.append(id)

	if players_ready.size() == players.size():
		for p in players:
			rpc_id(p, "post_start_game")
		post_start_game()


func host_game(new_player_name):
	player_name = new_player_name
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(host)
	var id = get_tree().get_rpc_sender_id()


func join_game(ip, new_player_name):
	player_name = new_player_name
	var client = NetworkedMultiplayerENet.new()
	client.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(client)

func all_ready():
	if players_blue.size() + players_red.size() == players.size() + 1:
		return true
	return false

func get_player_list():
	return players.values()

func get_players():
	return players

func get_player_name():
	return player_name

remote func set_players_blue(id):
	if not id in players_red and not id in players_blue:
		players_blue.append(id)

remote func set_players_red(id):
	if not id in players_red and not id in players_blue:
		players_red.append(id)

# Functionality for the startmenu in the network
func start_menu():
	assert(get_tree().is_network_server())
	
	for p in players:
		rpc_id(p, "load_start_menu")
	load_start_menu()


remote func load_start_menu():
	var StartMenu = load("res://src/scenes/StartMenu/StartMenu.tscn").instance()
	get_tree().get_root().add_child(StartMenu)
	get_tree().get_root().get_node("Main").hide()


func begin_game():
	assert(get_tree().is_network_server())
	
	# Create a dictionary with peer id and respective spawn points, could be improved by randomizing.
	var spawn_points_blue = {}
	var spawn_points_red = {}
	
	var spawn_point_idx = 0
	for p in players_blue:
		spawn_points_blue[p] = spawn_point_idx
		spawn_point_idx += 1
	for p in players_red:
		spawn_points_red[p] = spawn_point_idx
		spawn_point_idx += 1
	# Call to pre-start game with the spawn points.
	
	for p in players:
		rpc_id(p, "pre_start_game", spawn_points_blue, spawn_points_red)
	pre_start_game(spawn_points_blue, spawn_points_red)


func end_game():
	if has_node("res://src/scenes/Level.tscn"): # Game is in progress.
		# End it
		get_node("res://src/scenes/Level.tscn").queue_free()

	emit_signal("game_ended")
	players.clear()



# Emit what attack the red player selected
func red_attack_selected(attack_type):
	emit_signal("attack_selected", attack_type)

# Emit what computer red player selected
func computer_selected(id):
	if players_red.has(get_tree().get_network_unique_id()):
		emit_signal("computer_selected", id)

# Handles all attacks
func attack_timer(id, status):
	if (status == "start"):
		emit_signal("attack_started", id)	
	if (status == "finished"):
		emit_signal("attack_finished", id)
	if(status == "unfinished"):
		emit_signal("attack_unsuccesful", id)



func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
