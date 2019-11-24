extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var asteroid = preload("res://scenes/instances/asteroid0.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(1, false)
	timer.connect("timeout", self, "spawn_asteroid")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	pass
	
func spawn_asteroid():
	var pos = Vector3(rand_range(-50, 50), rand_range(-50, 50), 0)
	var dir = -pos.normalized()
	
	var obj = asteroid.instance()
	obj.translation = pos
	obj.scale = Vector3(1, 1, 1) * rand_range(0.2, 2)
	
	var scalar = rand_range(5, 50)
	var body = obj.get_node("RigidBody")
	body.linear_velocity = dir * scalar
	body.mass = scalar * scalar
	
	add_child(obj)
	
	var timer = get_tree().create_timer(1, false)
	timer.connect("timeout", self, "spawn_asteroid")
