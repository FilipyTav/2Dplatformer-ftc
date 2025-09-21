extends Node2D

# --- Nodes ---
@onready var links: Sprite2D = $Links
@onready var hook_tip: Sprite2D = $Tip

@onready var ray: RayCast2D = $RayCast2D
@onready var player: CharacterBody2D = get_parent()
@onready var rope: Line2D = $Line2D

# --- Config vars ---
@export var rest_length = 200.0
@export var stiffness = 15.0
@export var damping = 1.0

var launched: bool = false
var target_pos: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	ray.look_at(get_global_mouse_position())
	ray.rotation += deg_to_rad(-90)

	if Input.is_action_just_pressed("hook"):
		launch()

	if Input.is_action_just_released("hook"):
		retract()

	if launched:
		handle_grapple(delta)

func launch() -> void:
	if ray.is_colliding():
		launched = true
		target_pos = ray.get_collision_point()

func retract() -> void:
	launched = false

func handle_grapple(delta: float) -> void:
	var target_dir: Vector2 = player.global_position.direction_to(target_pos)
	var target_dist: float = player.global_position.distance_to(target_pos)

	var displacement: float = target_dist - rest_length

	var force = Vector2.ZERO

	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude

		var vel_dot = player.velocity.dot(target_dir)
		var dmp = -damping * vel_dot * target_dir

		force = spring_force * dmp

	player.velocity += force * delta
	update_rope()
	update_tip(to_local(target_pos))

func update_rope() -> void:
	rope.set_point_position(1, to_local(target_pos))

func update_tip(pos: Vector2) -> void:
	hook_tip.position = pos
	hook_tip.rotation = pos.angle()
	hook_tip.rotation += deg_to_rad(90)
