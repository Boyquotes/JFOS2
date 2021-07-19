extends Reference

const list = [
	preload("res://scenes/instances/asteroid0.tscn"),
	preload("res://scenes/instances/asteroid1.tscn"),
	preload("res://scenes/instances/asteroid2.tscn"),
	preload("res://scenes/instances/asteroid3.tscn"),
	preload("res://scenes/instances/asteroid4.tscn"),
	preload("res://scenes/instances/asteroid5.tscn"),
	preload("res://scenes/instances/asteroid6.tscn"),
	preload("res://scenes/instances/asteroid7.tscn"),
	preload("res://scenes/instances/asteroid8.tscn"),
	preload("res://scenes/instances/asteroid9.tscn")
]

func create(rng: RandomNumberGenerator, pos: Vector3, linear_velocity: Vector3, angular_velocity: Vector3, scale: float) -> Spatial:
	var obj = list[rng.randi_range(0, list.size() - 1)].instance()
	obj.translation = pos
	obj.scale = Vector3(scale, scale, scale)
	
	var body = obj.get_node("RigidBody")
	body.linear_velocity = linear_velocity
	body.angular_velocity = angular_velocity
	body.mass *= (4 / 3) * PI * pow(scale / 2, 3) * 30
	
	return obj
