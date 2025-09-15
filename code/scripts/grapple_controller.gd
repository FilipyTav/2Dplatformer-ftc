extends Node2D

# ---- Config ----
@export var hook_speed: float = 900.0           # speed player moves toward hook
@export var rope_extend_speed: float = 1400.0   # visual rope speed
@export var stop_distance: float = 8.0          # distance to stick
@export var max_rope_distance: float = 300.0    # max rope reach

# ---- Nodes ----
@onready var ray: RayCast2D = $RayCast2D
@onready var player: CharacterBody2D = get_parent()
@onready var rope: Line2D = $Rope

# ---- State ----
var extending: bool = false
var retracting: bool = false
var hooked: bool = false

# ---- Vars ----
var rope_direction: Vector2 = Vector2.ZERO
var rope_length: float = 0.0
var target_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	rope.clear_points()
	rope.add_point(Vector2.ZERO)
	rope.add_point(Vector2.ZERO)
	rope.hide()

# BUG: extends more when retracting
# stays in place if objects move
# gotta have cooldown?
func _physics_process(delta: float) -> void:
	# Fire hook
	if Input.is_action_just_pressed("hook"):
		fire_rope()
	# Release hook
	if Input.is_action_just_released("hook") && !extending:
		start_retraction()

	# State machine
	if extending:
		extend_rope(delta)
	elif retracting:
		retract_rope(delta)
	elif hooked:
		pull_player(delta)

	if Input.is_action_just_pressed("print"):
		print(extending)
		print(retracting)
		print(hooked)

func fire_rope() -> void:
	rope.show()
	extending = true
	retracting = false
	hooked = false
	rope_length = 0.0

	# Direction toward mouse
	rope_direction = (get_global_mouse_position() - player.global_position).normalized()
	target_pos = player.global_position

func extend_rope(delta: float) -> void:
	rope_length += rope_extend_speed * delta
	if rope_length >= max_rope_distance:
		rope_length = max_rope_distance
		extending = false
		retracting = true
		return

	var tip = player.global_position + rope_direction * rope_length
	rope.set_point_position(0, rope.to_local(player.global_position))
	rope.set_point_position(1, rope.to_local(tip))

	# Check collision with layer-only targets
	ray.target_position = ray.to_local(tip)
	ray.force_raycast_update()
	if ray.is_colliding():
		target_pos = ray.get_collision_point()
		hooked = true
		extending = false
		rope_length = player.global_position.distance_to(target_pos)
		update_rope()

func retract_rope(delta: float) -> void:
	rope_length -= rope_extend_speed * delta
	if rope_length <= 0:
		rope_length = 0
		retracting = false
		rope.hide()
		return

	var tip = player.global_position + rope_direction * rope_length
	rope.set_point_position(0, rope.to_local(player.global_position))
	rope.set_point_position(1, rope.to_local(tip))

func pull_player(delta: float) -> void:
	var to_hook = target_pos - player.global_position
	var dist = to_hook.length()

	if dist > stop_distance:
		var dir = to_hook.normalized()
		player.grappling = true
		player.velocity = dir * hook_speed
		update_rope()
	else:
		player.grappling = true
		player.velocity = Vector2.ZERO
		update_rope()

func start_retraction() -> void:
	if extending or hooked:
		extending = false
		hooked = false
		retracting = true
		player.grappling = false

func update_rope() -> void:
	rope.set_point_position(0, rope.to_local(player.global_position))
	rope.set_point_position(1, rope.to_local(target_pos))
