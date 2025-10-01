extends RayCast2D

var on_floor: bool = true

signal floor_changed(on_floor: bool)
var last_on_floor: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.is_colliding():
		on_floor = true
		if !last_on_floor:
			floor_changed.emit(on_floor)
			last_on_floor = true
	else:
		on_floor = false
		if last_on_floor:
			floor_changed.emit(on_floor)
			last_on_floor = false
