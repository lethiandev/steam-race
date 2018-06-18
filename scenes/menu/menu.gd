extends Node

func _ready():
	# unique name
	randomize()
	$MenuPanel/JoinWindowDialog/VBoxContainer/NameInput.text += "_%d" % randi()

func _host_game(name, port):
	var peer = NetworkedMultiplayerENet.new()
	if peer.create_server(port, 16) == OK:
		_continue_to_lobby(name, peer)
	else:
		Debug.put("Failed to create the server, possibly port blocked", Debug.STATUS_ERR)

func _join_game(name, ip, port):
	var peer = NetworkedMultiplayerENet.new()
	if peer.create_client(ip, port) == OK:
		_continue_to_lobby(name, peer)
	else:
		Debug.put("Failed to connect to the server", Debug.STATUS_ERR)

func _continue_to_lobby(name, peer):
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_name", name)
	get_tree().set_meta("network_peer", peer)
	get_tree().change_scene("res://scenes/lobby_room/lobby_room.tscn")
