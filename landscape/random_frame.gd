extends Sprite

export(bool) var random_flip_h = true
export(bool) var random_flip_v = false

func _ready():
	frame = randi() % (hframes * vframes)
	flip_h = (randi()%2) if random_flip_h else false
	flip_v = (randi()%2) if random_flip_v else false
