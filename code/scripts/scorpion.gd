extends Node2D

const speed: float = 60.0

var direction: int = 1

@onready var ray_left = $RayLeft
@onready var ray_right = $RayRight
@onready var animated_sprite = $AnimatedSprite2D
@onready var body: CollisionShape2D = $Killzone/Body
@onready var tail: CollisionShape2D = $Killzone/Tail
@onready var floor_detection: RayCast2D = $FloorDetection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	floor_detection.floor_changed.connect(_floor_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (ray_right.is_colliding()):
		direction = -1
		animated_sprite.flip_h = false
	if (ray_left.is_colliding()):
		direction = 1
		animated_sprite.flip_h = true
	update_child_position(tail)
	position.x += direction * speed * delta
	
	
# This function will update the child node's position based on the parent's flip state
func update_child_position(node: Node2D):
	# left
	if animated_sprite.flip_h:
		# Flip the child's X position relative to the parent’s origin
		node.position.x = -abs(node.position.x)
	# right
	else:
		# Ensure the child node's position is set correctly when not flipped
		node.position.x = abs(node.position.x)

# TODO:
func change_dir() -> void:
	pass

func _floor_changed(on_floor: bool):
	print(on_floor)
	pass
