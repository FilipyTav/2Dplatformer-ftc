extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.checked = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
