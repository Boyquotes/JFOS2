extends Spatial

func _ready():
	get_tree().get_root().connect("size_changed", self, "resize")

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		
		# Workaround for wrong mouse bounds
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func resize():
	var min_size = Vector2(640, 480)
	if OS.window_size.x < min_size.x:
		OS.window_size.x = min_size.x
	if OS.window_size.y < min_size.y:
		OS.window_size.y = min_size.y

func start_game():
	if is_game_active():
		return
	
	get_node("Title").queue_free()
	get_node("CanvasLayer/TitleMenu").visible = false
	
	var game = load("res://scenes/game.tscn").instance()
	add_child(game)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func stop_game():
	if !is_game_active():
		return
	
	get_node("Game").queue_free()
	get_node("CanvasLayer/TitleMenu").visible = true
	set_paused(false)
	
	var game = load("res://scenes/title.tscn").instance()
	add_child(game)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func is_game_active():
	return has_node("Game")

func set_paused(paused: bool):
	if is_game_active():
		get_tree().paused = paused
		get_node("CanvasLayer/PauseMenu").visible = paused
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CONFINED)

func toggle_pause():
	set_paused(!get_tree().paused)
