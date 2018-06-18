extends Label

onready var format = get_text()

func set_value(value):
	set_text(format % [value])
