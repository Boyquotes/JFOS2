extends RigidBody

var last_angle = 0

func _integrate_forces(state):
	# Force the ship back in bounds if it gets out somehow (typically due to window resize)
	var proj_size = Common.get_projection_size()
	if state.transform.origin.x < -proj_size.x / 2 || state.transform.origin.x > proj_size.x / 2:
		state.transform.origin.x = clamp(state.transform.origin.x, -proj_size.x / 2, proj_size.x / 2)
	if state.transform.origin.y < -proj_size.y / 2 || state.transform.origin.y > proj_size.y / 2:
		state.transform.origin.y = clamp(state.transform.origin.y, -proj_size.y / 2, proj_size.y / 2)
	
	var force_pos = get_node("RearThruster").translation
	
	if Input.is_action_pressed("move_forward"):
		state.add_force(state.transform.basis.z * -30, force_pos)
	if Input.is_action_pressed("move_backward"):
		state.add_force(state.transform.basis.z * 30, Vector3(0, 0, 0))
	if Input.is_action_pressed("move_left"):
		state.add_force(state.transform.basis.x * -30, Vector3(0, 0, 0))
	if Input.is_action_pressed("move_right"):
		state.add_force(state.transform.basis.x * 30, Vector3(0, 0, 0))
	if Input.is_action_pressed("rotate_left"):
		state.add_torque(Vector3(0, 0, 1) * 30)
	if Input.is_action_pressed("rotate_right"):
		state.add_torque(Vector3(0, 0, 1) * -30)
	
	var camera = get_viewport().get_camera()
	if camera:
		var mouse_pos = get_viewport().get_mouse_position()
		var projected_mouse = camera.project_position(mouse_pos, camera.translation.z)
		var direction = projected_mouse.direction_to(state.transform.origin)
		
		var angle = state.transform.basis.z.angle_to(direction) * sign(state.transform.basis.z.cross(direction).z)
		state.angular_velocity.z = angle * 5
