extends RigidBody2D

var root_body

func _enter_tree():
	_find_root_body()

func _integrate_forces(state):
	root_body._wheel_integrate_forces(state)

func _find_root_body():
	root_body = get_parent()
	while root_body:
		if root_body is RigidBody2D:
			return root_body
		root_body = root_body.get_parent()
