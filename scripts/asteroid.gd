extends RigidBody

var Asteroids = load("res://scripts/includes/asteroid_spawner.gd").new()
var rng = RandomNumberGenerator.new()
var health : int = 100

func _ready():
	rng.randomize()
	health = 100 * global_transform.basis.get_scale().x

func _physics_process(delta):
	if health <= 0:
		var scalar = global_transform.basis.get_scale().x
		if scalar > 0.3:
			var split_count = rng.randi_range(3, 5)
			for i in range(0, split_count):
				var angle = PI * 2 * (float(i) / split_count)
				var pos_offset = Vector3(cos(angle), sin(angle), 0) * 3 * scalar
				var vel_offset = pos_offset.normalized() * rng.randf_range(1, 5)
				var ang_vel = Vector3(rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5))
				var new_scalar = scalar / rng.randf_range(2, 2.5)
				
				var asteroid = Asteroids.create(rng, global_transform.origin + pos_offset, linear_velocity + vel_offset, ang_vel, new_scalar)
				get_parent().get_parent().add_child(asteroid)
		
		get_parent().queue_free()

func hurt(damage: int):
	health -= damage
