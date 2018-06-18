extends RigidBody2D

signal steam_power_changed(value)
signal speed_changed(value)

var player = null
var steam_power = 0 setget set_steam_power

onready var is_master = is_network_master()
onready var buddy = $Buddy

onready var _net_position = global_position
onready var _net_rotation = global_rotation
onready var _net_linear_velocity = linear_velocity
onready var _net_angular_velocity = angular_velocity

func _ready():
	rset_config("steam_power", RPC_MODE_REMOTE)
	rset_config("_net_position", RPC_MODE_REMOTE)
	rset_config("_net_rotation", RPC_MODE_REMOTE)
	rset_config("_net_linear_velocity", RPC_MODE_REMOTE)
	rset_config("_net_angular_velocity", RPC_MODE_REMOTE)
	
	is_master = is_network_master()
	
	if not is_network_master():
		# disable gravity on slaves
		gravity_scale = 0
		modulate = Color(0.75, 0.75, 0.75, 1.0)
		# remove control panels
		$PlayerInterface.queue_free()

func add_steam_power(value):
	set_steam_power(steam_power + value)

func _integrate_forces(state):
	# decrease steam power
	set_steam_power(steam_power - steam_power * state.step)
	
	$Train/Particles2D1.emitting = steam_power > 10
	$Train/Particles2D2.emitting = steam_power > 1000
	$Train/Particles2D3.emitting = steam_power > 1500
	$Train/Particles2D4.emitting = steam_power > 2500
	
	# sync physics state
	if not is_network_master():
		state.transform = Transform2D(_net_rotation, _net_position)
		state.linear_velocity = _net_linear_velocity
		state.angular_velocity = _net_angular_velocity
	
	emit_signal("speed_changed", state.linear_velocity.length())

func _wheel_integrate_forces(state):
	state.angular_velocity += steam_power * state.step

func _input(event):
	if is_network_master():
		_process_input(event)

func _process_input(event):
	if event.is_action("ui_left") and event.pressed:
		buddy.take_coal()
	if event.is_action("ui_right") and event.pressed:
		if buddy.put_coal():
			add_steam_power(300)

func _physics_process(delta):
	# sync variables with other players
	if is_network_master():
		rset_unreliable("steam_power", steam_power)
		rset_unreliable("_net_position", global_position)
		rset_unreliable("_net_rotation", global_rotation)
		rset_unreliable("_net_linear_velocity", linear_velocity)
		rset_unreliable("_net_angular_velocity", angular_velocity)

func set_steam_power(value):
	steam_power = value
	emit_signal("steam_power_changed", steam_power)
