extends Area

func _ready():
	connect("body_exited", self, "remove_asteroid")

func _physics_process(delta):
	var proj_size = Common.get_projection_size()
	var shape = get_node("CollisionShape").shape
	shape.extents.x = proj_size.x
	shape.extents.y = proj_size.y

func remove_asteroid(body):
	if "Asteroid" in body.get_parent().name:
		body.get_parent().queue_free()
