extends Control

signal race_started()

var race_status = false
var ticks = 0

func _process(delta):
	ticks += delta
	
	if not race_status and ticks > 1.0:
		ticks -= int(ticks)
		$TimerLabel.text = str(int($Timer.time_left) + 1)
	
	if race_status and ticks > 3.0:
		queue_free()

func _on_Timer_timeout():
	$TimerLabel.text = "Go!"
	
	if get_tree().is_network_server():
		rpc("start_race")

sync func start_race():
	emit_signal("race_started")
	race_status = true
	ticks = 0
