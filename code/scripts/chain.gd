extends Node2D

# --- Nodes ---
@onready var links: Sprite2D = $Links
@onready var hook_tip: Sprite2D = $Tip

@onready var ray: RayCast2D = $RayCast2D
@onready var player: CharacterBody2D = get_parent()
@onready var rope: Line2D = $Line2D

# --- Config vars ---
@export var rest_length = 50.0
@export var stiffness = 300.0
@export var damping = 1.0
# distance to stick
@export var stop_distance: float = 4.0

var launched: bool = false
var target_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	ray.hide()
	self.visible = false

func _process(delta: float) -> void:
	ray.look_at(get_global_mouse_position())
	ray.rotation += deg_to_rad(-90)

	if Input.is_action_just_pressed("hook"):
		launch()

	if Input.is_action_just_released("hook"):
		retract()

	if launched:
		handle_grapple(delta)
	else:
		retract()

func launch() -> void:
	if ray.is_colliding():
		launched = true
		target_pos = ray.get_collision_point()
		self.visible = true

func retract() -> void:
	launched = false
	self.visible = false

func pull_player():
	var speed_factor: float = 20.0        # How fast speed grows with distance
	var min_speed: float = 300.0          # Minimum pull speed (when close)
	var max_speed: float = stiffness          # Maximum pull speed (when far)

	var target_dir: Vector2 = player.global_position.direction_to(target_pos)
	var target_dist: float = player.global_position.distance_to(target_pos)

	# var displacement: float = target_dist - rest_length

	if target_dist > stop_distance:
		# Easing: speed scales with distance, but capped
		var speed = clamp(target_dist * speed_factor, min_speed, max_speed)
		player.velocity = target_dir.normalized() * speed  # Full-speed pull
	else:
		player.velocity = Vector2.ZERO  # Immediate stop


func handle_grapple(_delta: float) -> void:
	pull_player()

	update_rope()
	update_tip(to_local(target_pos))
	update_link()

func update_rope() -> void:
	rope.set_point_position(1, to_local(target_pos))

func update_tip(pos: Vector2) -> void:
	hook_tip.position = pos
	hook_tip.rotation = pos.angle()
	hook_tip.rotation += deg_to_rad(90)

func update_link() -> void:
	var start_pos: Vector2 = rope.get_point_position(0)
	var end_pos: Vector2 = rope.get_point_position(1)

	var dir: Vector2 =  end_pos - start_pos
	var length: float = dir.length()
	var angle: float = dir.angle()
	var tex: Vector2 = links.texture.get_size()

	links.rotation = angle

	var total_links: float = length / (tex.x * links.scale.x)

	links.region_rect = Rect2(0, 0, total_links * tex.x, tex.y)
	links.offset.x = (tex.x * total_links) / 2
