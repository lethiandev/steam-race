extends Node

const TestTrain = preload("res://scenes/test_scene/test_train.tscn")

func _ready():
	var players = get_tree().get_meta("network_players")
	
	for i in range(players.size()):
		_create_player_train(players[i], i)
	
	# move master player's train to top
	for player in players:
		if player.id == get_tree().get_network_unique_id():
			var train = player.train_ref.get_ref()
			$Players.move_child(train, $Players.get_child_count() - 1)

func _create_player_train(player, maskshift):
	var train = TestTrain.instance()
	train.set_network_master(player.id)
	train.set_name(train.name + "_" + str(player.id))
	train.set_recursive_collision_layer(1 << maskshift)
	train.set_recursive_collision_mask(1 << maskshift)
	train.get_node("Train/Train/Control/Label").set_text(player.name)
	
	train.get_node("Train").player = player
	player.train_ref = weakref(train)
	
	$Players.add_child(train)
	
	# make camera current for master player
	if player.id == get_tree().get_network_unique_id():
		train.get_node("Train/Camera2D").current = true
	
	# connect the train with timer
	$InterfaceLayer/TimerPanel.connect("race_started", train, "allow_input_process")
