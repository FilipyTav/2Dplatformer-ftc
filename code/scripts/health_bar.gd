extends HBoxContainer

enum Mode {SIMPLE, EMPTY, PARTIAL}

var heart_full = preload("res://assets/sprites/HUD/hud_heartFull.png")
var heart_empty = preload("res://assets/sprites/HUD/hud_heartEmpty.png")
var heart_half = preload("res://assets/sprites/HUD/hud_heartHalf.png")

@export var mode : Mode = Mode.EMPTY

func populate(max_health: int) -> void:
	if self.get_child_count() >= max_health:
		return

	for i in range(1, max_health):
		var heart: TextureRect = $'1'.duplicate()
		self.add_child(heart)

func update_health(value: int):
	match mode:
		Mode.SIMPLE:
			update_simple(value)
		Mode.EMPTY:
			update_empty(value)
		Mode.PARTIAL:
			update_partial(value)

func update_simple(value):
	for i in get_child_count():
		get_child(i).visible = value > i

func update_empty(value):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_empty

func update_partial(value):
	for i in get_child_count():
		if value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty
