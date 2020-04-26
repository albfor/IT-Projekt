extends Node

# Default game port. Can be any number between 1024 and 49151.
const DEFAULT_PORT = 5002

#Max number of players on a server
const MAX_PLAYERS = 10

#Default player name
var player_name = "Player 1"

func host_game(new_player_name):
	player_name = new_player_name
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(host)

func join_game(ip, new_player_name):
	player_name = new_player_name
	var client = NetworkedMultiplayerENet.new()
	client.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(client)
