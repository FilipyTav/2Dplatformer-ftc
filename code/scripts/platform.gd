# Useless, for now. Attach to node later.

extends AnimatableBody2D

@export var platform_texture: Texture2D

# The index of the sprite we want to display
# [0, 5]
@export_range(0, 7)
var sprite_index:int = 1

# This will be the child node that displays the texture
@onready var sprite_node: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Hitbox

var sprite_size: Vector2 = Vector2(16, 32)
var vertical_gap: int = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if platform_texture:
		# Create a new Rect2 for the desired region
		var rect_region: Rect2 = Rect2() # (x, y, w, h)
		# Size
		rect_region.size.x = int(sprite_size.x) if sprite_index % 2 == 0 else int(sprite_size.y)
		rect_region.size.y = 9
		# Position
		rect_region.position.x = 0 if sprite_index % 2 == 0 else int(sprite_size.x)
		rect_region.position.y = (vertical_gap + rect_region.size.y) * int(sprite_index / 2.0)
		# 0-1 = 0
		# 2-3 = 1
		# 4-5 = 2
		# 6-7 = 3
		# Get the shape from the CollisionShape2D node
		var rect_coll_shape = collision_shape.shape as RectangleShape2D

		# Set the new size
		print("done?")
		rect_coll_shape.size = Vector2(rect_region.size.x, rect_region.size.y - 1)

		# Assign the Rect2 to the Sprite2D's region_rect
		$Sprite2D.region_rect = rect_region
		sprite_node.region_enabled = true
		# sprite_node.texture = platform_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
