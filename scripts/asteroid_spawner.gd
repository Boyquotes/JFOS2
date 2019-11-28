extends Spatial

var asteroids = [
	preload("res://scenes/instances/asteroid0.tscn"),
	preload("res://scenes/instances/asteroid1.tscn"),
	preload("res://scenes/instances/asteroid2.tscn"),
	preload("res://scenes/instances/asteroid3.tscn"),
	preload("res://scenes/instances/asteroid4.tscn")
]
var rng = RandomNumberGenerator.new()

func _ready():
	var timer = get_tree().create_timer(1, false)
	timer.connect("timeout", self, "spawn_asteroid")

#func _process(delta):
#	pass

func spawn_asteroid():
	var proj_size = Common.get_projection_size(get_node("Camera"))
	
	var pos = Vector3(rng.randf_range(-proj_size.x, proj_size.x), rng.randf_range(-proj_size.y, proj_size.y), 0)
	if pos.x < 0:
		pos.x = clamp(pos.x, -proj_size.x, -proj_size.x / 2 - 10)
	else:
		pos.x = clamp(pos.x, proj_size.x / 2 + 10, proj_size.x)
	if pos.y < 0:
		pos.y = clamp(pos.y, -proj_size.y, -proj_size.y / 2 - 10)
	else:
		pos.y = clamp(pos.y, proj_size.y / 2 + 10, proj_size.y)
	
	var dir = -pos.normalized()
	
	var obj = asteroids[rng.randi_range(3, asteroids.size() - 1)].instance()
	obj.translation = pos
	
	var scalar = rng.randf_range(0.2, 2)
	obj.scale = Vector3(scalar, scalar, scalar)
	
	var body = obj.get_node("RigidBody")
	body.linear_velocity = dir * rng.randf_range(5, 50)
	body.angular_velocity = Vector3(rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5))
	body.mass *= (4 / 3) * PI * pow(scalar / 2, 3)
	
	add_child(obj)
	
	var timer = get_tree().create_timer(1, false)
	timer.connect("timeout", self, "spawn_asteroid")
