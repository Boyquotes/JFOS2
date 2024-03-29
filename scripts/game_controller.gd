extends Spatial

var Asteroids = preload("res://scripts/includes/asteroid_spawner.gd").new()
var rng = RandomNumberGenerator.new()
var spawn_angle = 0

func _ready():
	rng.randomize()
	spawn_angle = rng.randf_range(0, PI * 2)
	
	var timer = Timer.new()
	timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	timer.wait_time = 1.5
	timer.autostart = true
	timer.connect("timeout", self, "spawn_asteroid")
	add_child(timer)

func _process(delta):
	var dir = Vector2(cos(spawn_angle), sin(spawn_angle))
	var material = get_node("Background").get_surface_material(0)
	var pos = material.get_shader_param("position")
	material.set_shader_param("position", pos + dir * 0.00005)

func spawn_asteroid():
	var proj_size = Common.get_projection_size()
	var mid_factor = 0.75
	var deviation = (min(proj_size.x, proj_size.y) / 2) * mid_factor
	
	var ray_pos = Vector3(cos(spawn_angle), sin(spawn_angle), 0) * max(proj_size.x, proj_size.y)
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(ray_pos, Vector3(0, 0, 0), [], 0x8, false, true)
	
	if result.empty():
		print("Empty raytrace result!")
		return
	var base_pos = result.get("position").normalized() * max(proj_size.x, proj_size.y) * mid_factor
	
	var cross = (-base_pos.normalized()).cross(Vector3(0, 0, 1))
	var pos = base_pos + (cross * rng.randf_range(-deviation, deviation))
	var dir = -(base_pos + (cross * rng.randf_range(-deviation, deviation))).normalized()
	
	var linear_velocity = dir * rng.randf_range(5, 20)
	var angular_velocity = Vector3(rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5))
	var scalar = clamp(pow(2, rng.randfn(0, 0.5)) * 0.6, 0.1, 3.0)
	
	var asteroid = Asteroids.create(rng, pos, linear_velocity, angular_velocity, scalar)
	add_child(asteroid)
