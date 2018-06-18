extends Node2D

func _ready():
	# disable input processing
	# wait for the race begin
	$Train.set_process_input(false)

func set_recursive_collision_layer(bitmask):
	$Train.collision_layer = bitmask
	$Train/Wheels/RearWheel.collision_layer = bitmask
	$Train/Wheels/MidWheel.collision_layer = bitmask
	$Train/Wheels/FrontWheel.collision_layer = bitmask
	$Cargo1.collision_layer = bitmask
	$Cargo1/Wheels/RearWheel.collision_layer = bitmask
	$Cargo1/Wheels/FrontWheel.collision_layer = bitmask
	$Cargo2.collision_layer = bitmask
	$Cargo2/Wheels/RearWheel.collision_layer = bitmask
	$Cargo2/Wheels/FrontWheel.collision_layer = bitmask

func set_recursive_collision_mask(bitmask):
	$Train.collision_mask = bitmask
	$Train/Wheels/RearWheel.collision_mask = bitmask
	$Train/Wheels/MidWheel.collision_mask = bitmask
	$Train/Wheels/FrontWheel.collision_mask = bitmask
	$Cargo1.collision_mask = bitmask
	$Cargo1/Wheels/RearWheel.collision_mask = bitmask
	$Cargo1/Wheels/FrontWheel.collision_mask = bitmask
	$Cargo2.collision_mask = bitmask
	$Cargo2/Wheels/RearWheel.collision_mask = bitmask
	$Cargo2/Wheels/FrontWheel.collision_mask = bitmask

sync func allow_input_process():
	$Train.set_process_input(true)
