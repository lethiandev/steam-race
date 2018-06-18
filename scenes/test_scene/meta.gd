extends Area2D

signal train_passed(train)

const Train = preload("res://vehicles/train/train.gd")

func _on_landscape_generated(endpos):
	set_position(endpos)
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body is Train:
		emit_signal("train_passed", body)
