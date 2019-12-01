extends Node

func get_projection_size():
	var camera = get_viewport().get_camera()
	if not camera:
		return Vector2(30, 30)
	
	var view_size = get_viewport().get_visible_rect().size
	if camera.keep_aspect == Camera.KEEP_HEIGHT:
		var view_ratio = view_size.x / view_size.y
		return Vector2(camera.size * view_ratio, camera.size)
	else:
		var view_ratio = view_size.y / view_size.x
		return Vector2(camera.size, camera.size * view_ratio)
