extends Control

func _ready():
	hide()

func _on_meta_train_passed(train):
	Debug.put("Player %s passed the meta" % train.player.name)
	
	if train.is_master:
		rpc_id(1, "winner_is_only_one", train.player)

master func winner_is_only_one(player):
	if not visible:
		rpc("post_player_win", player)

sync func post_player_win(winner):
	Debug.put("Player %s is the winner!" % winner.name, Debug.STATUS_SUCCESS)
	$WinnerNameLabel.text = $WinnerNameLabel.text % winner.name
	show()
