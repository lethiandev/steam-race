extends WindowDialog

signal game_hosted(name, port)

func _on_host_button_pressed():
	var namev = $VBoxContainer/NameInput.text
	var portv = int($VBoxContainer/PortInput.text)
	emit_signal("game_hosted", namev, portv)
