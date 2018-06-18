tool
extends Polygon2D

signal landscape_generated(endpos)

const SoftNoise = preload("res://scripts/softnoise.gd").SoftNoise

const Decorations = [
	preload("res://landscape/cactus.tscn")
]

export(float) var start_width = 1024 setget set_start_width

func _ready():
	_update_landscape()

func _update_landscape():
	if not Engine.editor_hint:
		_generate_landscape()
		_update_landscape_collision()
	else:
		_preview_landscape()

func _generate_landscape():
	var top = [
		Vector2(-1000, 0),
		Vector2(start_width, 0),
	]
	
	var randseed =  get_tree().get_meta("network_seed")
	var snoise = SoftNoise.new(randseed)
	var basey = snoise.openSimplex2D(0, 0) * 100
	
	seed(randseed)
	
	for i in range(500):
		var slope1 = snoise.openSimplex2D(i * 0.05, 0) * 100 - basey
		var slope2 = snoise.openSimplex2D(0, i * 0.1) * 50 - basey
		var topv = Vector2(
			top[-1].x + 50,
			slope1 + slope2
		)
		top.append(topv)
		
		if ((snoise.simple_noise1d(i * 100) / 2) + 0.5 < 0.45):
			_place_decoration(topv)
	
	# end of the route
	top.append(top[-1] + Vector2(500, 0))
	
	var bottom = []
	for i in range(top.size()):
		var topv = top[top.size() - i - 1]
		bottom.append(Vector2(topv.x, topv.y + 1000))
	
	polygon = top + bottom
	
	emit_signal("landscape_generated", top[-2])

func _place_decoration(pos):
	var decscene = Decorations[randi() % Decorations.size()]
	var decnode = decscene.instance()
	decnode.set_position(pos)
	
	$Decorations.add_child(decnode)

func _preview_landscape():
	polygon = [
		Vector2(0, 0),
		Vector2(start_width, 0),
		Vector2(start_width, 1000),
		Vector2(0, 1000),
	]

func _update_landscape_collision():
	if has_node("StaticBody2D/CollisionPolygon2D"):
		$StaticBody2D/CollisionPolygon2D.polygon = polygon

func set_start_width(value):
	start_width = value
	
	if is_inside_tree():
		_update_landscape()
