extends Spatial

var body
var last_velocity = Vector3()

func _ready():
	body = get_node("../../RigidBody")

func _physics_process(delta):
	var local_velocity = body.transform.basis.xform_inv(body.linear_velocity - last_velocity).normalized()
	last_velocity = body.linear_velocity
	
	var forward = body.is_accelerating && local_velocity.angle_to(Vector3(0, -1, 0)) < PI / 2
	get_node("Particles").emitting = forward
	get_node("Particles2").emitting = forward
	get_node("OmniLight").visible = forward
	
	var backward = body.is_accelerating && local_velocity.angle_to(Vector3(0, 1, 0)) < PI / 2
	# TODO
	
	var left = body.is_accelerating && local_velocity.angle_to(Vector3(1, 0, 0)) < PI / 2
	# TODO
	
	var right = body.is_accelerating && local_velocity.angle_to(Vector3(-1, 0, 0)) < PI / 2
	# TODO
