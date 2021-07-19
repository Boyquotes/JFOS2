extends Spatial

var Asteroids = preload("res://scripts/includes/asteroid_spawner.gd").new()
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
	var timer = Timer.new()
	timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	timer.wait_time = 0.6
	timer.autostart = true
	timer.connect("timeout", self, "spawn_asteroid")
	add_child(timer)

func spawn_asteroid():
	var proj_size = Common.get_projection_size()
	var mid_factor = 0.75
	var deviation = (min(proj_size.x, proj_size.y) / 2) * mid_factor
	
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
	
	var cross = (-pos.normalized()).cross(Vector3(0, 0, 1))
	var dir = -(pos + (cross * rng.randf_range(-deviation, deviation))).normalized()
	
	var linear_velocity = dir * rng.randf_range(5, 50)
	var angular_velocity = Vector3(rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5))
	var scalar = clamp(pow(2, rng.randfn(0, 0.5)) * 0.6, 0.1, 3.0)
	
	var asteroid = Asteroids.create(rng, pos, linear_velocity, angular_velocity, scalar)
	add_child(asteroid)
