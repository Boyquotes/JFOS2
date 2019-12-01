extends StaticBody

func _physics_process(delta):
	var proj_size = Common.get_projection_size()
	
	var left_box = get_node("LeftBox")
	left_box.translation.x = -proj_size.x / 2 - 10
	left_box.shape.extents.y = proj_size.y / 2 + 20
	
	var right_box = get_node("RightBox")
	right_box.translation.x = proj_size.x / 2 + 10
	right_box.shape.extents.y = proj_size.y / 2 + 20
	
	var top_box = get_node("TopBox")
	top_box.translation.y = proj_size.y / 2 + 10
	top_box.shape.extents.x = proj_size.x / 2 + 20
	
	var bottom_box = get_node("BottomBox")
	bottom_box.translation.y = -proj_size.y / 2 - 10
	bottom_box.shape.extents.x = proj_size.x / 2 + 20
