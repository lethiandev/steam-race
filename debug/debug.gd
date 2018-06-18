extends CanvasLayer

enum {
	STATUS_OK,
	STATUS_SUCCESS,
	STATUS_WARN,
	STATUS_ERR,
	STATUS_UNKNOWN
}

sync func put(message, status = STATUS_OK):
	var label = Label.new()
	label.set_text(message)
	label.set("custom_colors/font_color", _get_color(status))
	
	if $VBoxContainer.get_child_count() > 5:
		_pop_log()
	
	$VBoxContainer.add_child(label)
	$Timer.start()

func _get_color(status):
	if status == STATUS_OK:
		return ColorN("white")
	if status == STATUS_SUCCESS:
		return ColorN("green")
	if status == STATUS_WARN:
		return ColorN("yellow")
	if status == STATUS_ERR:
		return ColorN("crimson")
	return ColorN("gray")

func _pop_log():
	if $VBoxContainer.get_child_count() > 0:
		$VBoxContainer.get_child(0).queue_free()
