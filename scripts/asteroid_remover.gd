extends Area

func _ready():
	connect("body_exited", self, "remove_asteroid")

func _physics_process(delta):
	var proj_size = Common.get_projection_size()
	var shape = get_node("CollisionShape").shape
	shape.extents.x = max(proj_size.x, proj_size.y)
	shape.extents.y = max(proj_size.x, proj_size.y)

func remove_asteroid(body):
	if !body.is_in_group("unremoveable"):
		body.get_parent().queue_free()
