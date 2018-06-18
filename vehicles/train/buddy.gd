extends Sprite

func _ready():
	rset_config("flip_h", RPC_MODE_SYNC)

func take_coal():
	rset("flip_h", true)

func put_coal():
	if has_coal():
		rset("flip_h", false)
		$Particles2D.emitting = true
		return true
	return false

func has_coal():
	return flip_h
