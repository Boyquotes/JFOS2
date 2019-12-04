extends Spatial

var Asteroids = preload("res://scripts/includes/asteroid_spawner.gd").new()
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	spawn_asteroid()

func _process(delta):
	var proj_size = Common.get_projection_size()
	get_node("TestBG").scale.x = proj_size.x / 2
	get_node("TestBG").scale.z = proj_size.y / 2
	pass

func spawn_asteroid():
	var proj_size = Common.get_projection_size()
	
	var pos = Vector3()
	if rng.randf() < 0.5:
		if rng.randf() < 0.5:
			pos.x = rng.randf_range(-proj_size.x, -proj_size.x / 2 - 10)
		else:
			pos.x = rng.randf_range(proj_size.x / 2 + 10, proj_size.x)
		pos.y = rng.randf_range(-proj_size.y / 2 - 10, proj_size.y / 2 + 10)
	else:
		if rng.randf() < 0.5:
			pos.y = rng.randf_range(-proj_size.y, -proj_size.y / 2 - 10)
		else:
			pos.y = rng.randf_range(proj_size.y / 2 + 10, proj_size.y)
		pos.x = rng.randf_range(-proj_size.x / 2 - 10, proj_size.x / 2 + 10)
	
	var linear_velocity = -pos.normalized() * rng.randf_range(5, 50)
	var angular_velocity = Vector3(rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5))
	var scalar = rng.randf_range(0.2, 2)
	
	Asteroids.spawn(self, rng, pos, linear_velocity, angular_velocity, scalar)
	
	var timer = get_tree().create_timer(1.5, false)
	timer.connect("timeout", self, "spawn_asteroid")
