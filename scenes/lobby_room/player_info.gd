extends Control

export(String) var format = "%s (%d)"

var peer_name = "n/d"
var peer_id = 1
var peer_ready = false

func set_player(name, peerid):
	peer_name = name
	peer_id = peerid
	_update_label()

func set_ready(ready):
	peer_ready = ready
	_update_status()

func _update_label():
	$Label.text = format % [peer_name, peer_id]
	
	# highlight player	
	if is_inside_tree() and get_tree().get_network_unique_id() == peer_id:
		$Label.set("custom_colors/font_color", ColorN("green"))

func _update_status():
	$Status.modulate = ColorN("green" if peer_ready else "crimson")
