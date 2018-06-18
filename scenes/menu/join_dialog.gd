extends WindowDialog

signal game_joined(name, ip, port)

func _on_join_button_pressed():
	var namev = $VBoxContainer/NameInput.text
	var ipv = $VBoxContainer/IpInput.text
	var portv = int($VBoxContainer/PortInput.text)
	emit_signal("game_joined", namev, ipv, portv)
