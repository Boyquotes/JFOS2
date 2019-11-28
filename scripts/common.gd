extends Node

func get_projection_size(camera: Camera):
	var view_size = get_viewport().get_visible_rect().size
	var view_ratio = view_size.x / view_size.y
	var camera_size = camera.size
	return Vector2(camera_size * view_ratio, camera_size)
