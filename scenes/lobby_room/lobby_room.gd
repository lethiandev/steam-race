extends Node

const PlayerInfo = preload("res://scenes/lobby_room/player_info.tscn")

var network_seed = 0

onready var is_server = get_tree().is_network_server()
onready var player_list = $HBoxContainer/Lobby/PlayerList

func _ready():
	get_tree().set_refuse_new_network_connections(false)
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_disconnected")
	
	rset_config("network_seed", RPC_MODE_SYNC)
	
	if is_server:
		Debug.put("You are hosting the game")
		_create_player(get_tree().get_meta("network_name"), 1)
		
		randomize()
		network_seed = randi()
	else:
		Debug.put("Waiting to establish a connection with the server...")
		$HBoxContainer.hide()

func _peer_connected(peerid):
	Debug.put("Peer connected %d" % peerid, Debug.STATUS_SUCCESS)
	
	if is_server:
		rset_id(peerid, "network_seed", network_seed)

func _peer_disconnected(peerid):
	Debug.put("Peer disconnected %d" % peerid, Debug.STATUS_WARN)
	for child in player_list.get_children():
		if child.peer_id == peerid:
			child.queue_free()

func _connected_ok():
	Debug.put("Connection established with the server", Debug.STATUS_SUCCESS)
	rpc_id(1, "income_player", get_tree().get_meta("network_name"))
	$HBoxContainer.show()

func _connected_fail():
	Debug.put("Connection with the server failed", Debug.STATUS_ERR)
	get_tree().change_scene("res://scenes/menu/menu.tscn")

func _disconnected():
	Debug.put("Server disconnected", Debug.STATUS_ERR)
	get_tree().change_scene("res://scenes/menu/menu.tscn")

master func income_player(name):
	var peerid = get_tree().get_rpc_sender_id()
	var player = _get_player_node(peerid)
	
	if player:
		Debug.put("Player %s (%d) already exists" % [player.peer_name, player.peer_id])
		return
	
	Debug.put("Preparing player %s (%d)" % [name, peerid])
	player = _create_player(name, peerid)
	
	sync_player_nodes()

master func sync_player_nodes():
	for child in player_list.get_children():
		rpc("sync_player_node", child.peer_name, child.peer_id, child.peer_ready)

remote func sync_player_node(name, peerid, ready):
	var player = _get_player_node(peerid)
	
	if not player:
		_create_player(name, peerid, ready)
	else:
		player.set_player(name, peerid)
		player.set_ready(ready)

func _create_player(name, peerid, ready = false):
	var player = PlayerInfo.instance()
	player_list.add_child(player)
	player.set_player(name, peerid)
	player.set_ready(ready)
	
	return player

func _on_ready_button_pressed():
	var peerid = get_tree().get_network_unique_id()
	var player = _get_player_node(peerid)
	
	rpc("toggle_ready", player.peer_id, not player.peer_ready)

sync func toggle_ready(peerid, ready):
	var player = _get_player_node(peerid)
	
	if player:
		player.set_ready(ready)

func _get_player_node(peerid):
	for child in player_list.get_children():
		if child.peer_id == peerid:
			return child
	return null

func _on_start_button_pressed():
	if is_server:
		rpc("start_game", "res://scenes/test_scene/test_scene.tscn")

sync func start_game(scene):
	var netplayers = []
	for child in player_list.get_children():
		netplayers.push_back({
			name = child.peer_name,
			id = child.peer_id
		})
	
	if is_server:
		Debug.rpc("put", "Starting the game...")
	
	get_tree().set_refuse_new_network_connections(true)
	get_tree().set_meta("network_players", netplayers)
	get_tree().set_meta("network_seed", network_seed)
	get_tree().change_scene(scene)
