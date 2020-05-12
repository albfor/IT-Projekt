#Behövs fixas dynamiska nodepunkter om det går
extends Control

func _ready():
	# Ensure menus are hidden at s
	$Lobby.hide()
	# Called every time the node is added to the scene.
	Network.connect("connection_failed", self, "_on_connection_failed")
	Network.connect("connection_succeeded", self, "_on_connection_success")
	Network.connect("player_list_changed", self, "refresh_lobby")
	Network.connect("game_ended", self, "_on_game_ended")
	Network.connect("game_error", self, "_on_game_error")
	# Set the player name according to the system username. Fallback to the path.
	if OS.has_environment("USERNAME"):
		$Menu/CenterRow/Buttons/HBoxContainer/Name.text = OS.get_environment("USERNAME")
	else:
		var desktop_path = OS.get_system_dir(0).replace("\\", "/").split("/")
		$Menu/CenterRow/Buttons/HBoxContainer/Name.text = desktop_path[desktop_path.size() - 2]


func _on_HostGameButton_pressed():
	if $Menu/CenterRow/Buttons/HBoxContainer/Name.text == "":
		$Menu/CenterContainer/ErrorLabel.text = "Invalid name!"
		return

	$Menu.hide()
	$Lobby.show()
	$Menu/CenterContainer/ErrorLabel.text = ""

	var player_name = $Menu/CenterRow/Buttons/HBoxContainer/Name.text
	Network.host_game(player_name)
	refresh_lobby()


func _on_JoinGameButton_pressed():
	if $Menu/CenterRow/Buttons/HBoxContainer/Name.text == "":
		$Menu/CenterContainer/ErrorLabel.text = "Invalid name!"
		return


	var ip = $Menu/CenterRow/Buttons/HBoxContainer2/IP.text
	if not ip.is_valid_ip_address():
		$Menu/CenterContainer/ErrorLabel.text = "Invalid IP address!"
		return


	$Menu/CenterContainer/ErrorLabel.text = ""
	$Menu/CenterRow/Buttons/HBoxContainer/HostGameButton.disabled = true
	$Menu/CenterRow/Buttons/HBoxContainer2/JoinGameButton.disabled = true

	var player_name = $Menu/CenterRow/Buttons/HBoxContainer/Name.text
	Network.join_game(ip, player_name)


func _on_connection_success():
	$Menu.hide()
	$Lobby.show()


func _on_connection_failed():
	$Menu/CenterRow/Buttons/HBoxContainer/HostGameButton.disabled = false
	$Menu/CenterRow/Buttons/HBoxContainer2/JoinGameButton.disabled = false
	$Menu/CenterContainer/ErrorLabel.set_text("Connection failed.")


func _on_game_ended():
	show()
	$Menu.hide()
	$Lobby.show()
	$Menu/CenterRow/Buttons/HBoxContainer/HostGameButton.disabled = false
	$Menu/CenterRow/Buttons/HBoxContainer2/JoinGameButton.disabled = false


func _on_game_error(errtxt):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered_minsize()
	$Menu/CenterRow/Buttons/HBoxContainer/HostGameButton.disabled = false
	$Menu/CenterRow/Buttons/HBoxContainer2/JoinGameButton.disabled = false


func refresh_lobby():
	var players = Network.get_player_list()
	players.sort()
	$Lobby/PlayerList.clear()
	$Lobby/PlayerList.add_item(Network.get_player_name() + " (you)")
	for p in players:
		$Lobby/PlayerList.add_item(p)

	$Lobby/StartGameButton.disabled = not get_tree().is_network_server()


func _on_StartGameButton_pressed():
	Network.start_menu()
