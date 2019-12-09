extends RigidBody

const pulse_blast = preload("res://scenes/instances/pulse_blast.tscn")
var is_accelerating = false
var pulse_blaster_delay = 0

func _physics_process(delta):
	pulse_blaster_delay -= delta
	if Input.is_action_pressed("fire_primary") && pulse_blaster_delay <= 0:
		shoot_pulse()
		pulse_blaster_delay = 0.2

func shoot_pulse():
	for node in [get_node("LeftGun"), get_node("RightGun")]:
		var blast = pulse_blast.instance()
		blast.translation = node.global_transform.origin
		blast.motion = -global_transform.basis.y * 125 + linear_velocity
		get_parent().get_parent().add_child(blast)

func _integrate_forces(state):
	# Force the ship back in bounds if it gets out somehow (typically due to window resize)
	var proj_size = Common.get_projection_size()
	if state.transform.origin.x < -proj_size.x / 2 || state.transform.origin.x > proj_size.x / 2:
		state.transform.origin.x = clamp(state.transform.origin.x, -proj_size.x / 2, proj_size.x / 2)
	if state.transform.origin.y < -proj_size.y / 2 || state.transform.origin.y > proj_size.y / 2:
		state.transform.origin.y = clamp(state.transform.origin.y, -proj_size.y / 2, proj_size.y / 2)
	
	var tank_controls = false # TODO: option for this
	var x_force = state.transform.basis.x if tank_controls else Vector3(-1, 0, 0)
	var y_force = state.transform.basis.y if tank_controls else Vector3(0, -1, 0)
	var speed = 30
	
	is_accelerating = false
	if Input.is_action_pressed("move_forward"):
		state.add_force(y_force * -speed * Input.get_action_strength("move_forward"), Vector3())
		is_accelerating = true
	if Input.is_action_pressed("move_backward"):
		state.add_force(y_force * speed * Input.get_action_strength("move_backward"), Vector3())
		is_accelerating = true
	if Input.is_action_pressed("move_left"):
		state.add_force(x_force * speed * Input.get_action_strength("move_left"), Vector3())
		is_accelerating = true
	if Input.is_action_pressed("move_right"):
		state.add_force(x_force * -speed * Input.get_action_strength("move_right"), Vector3())
		is_accelerating = true
	
	var mouse_rotation = true # TODO: option for this
	
	if !mouse_rotation:
		if Input.is_action_pressed("rotate_left"):
			state.add_torque(Vector3(0, 0, -1) * -60 * Input.get_action_strength("rotate_left"))
		if Input.is_action_pressed("rotate_right"):
			state.add_torque(Vector3(0, 0, -1) * 60 * Input.get_action_strength("rotate_right"))
	else:
		var camera = get_viewport().get_camera()
		if camera:
			var mouse_pos = get_viewport().get_mouse_position()
			var projected_mouse = camera.project_position(mouse_pos, camera.translation.z)
			var direction = projected_mouse.direction_to(state.transform.origin)
			
			var angle = state.transform.basis.y.angle_to(direction) * sign(state.transform.basis.y.cross(direction).z)
			state.angular_velocity.z = angle * 5
	
	#for i in range(state.get_contact_count()):
	#	print(state.get_contact_impulse(i))
