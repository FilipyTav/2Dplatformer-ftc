extends Sprite2D

func set_property(tx_pos: Vector2, tx_scale: Vector2) -> void:
	position = tx_pos
	scale = tx_scale

func ghosting() -> void:
	var tween_fade: Tween = get_tree().create_tween()

	tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), .75)
	await tween_fade.finished

	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ghosting()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
