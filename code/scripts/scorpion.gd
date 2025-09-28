extends Node2D

@export var max_health: int = 1
@export var max_speed: float = 60.0
var speed: float = 60.0

var health: int = 0
var direction: int = 1

@onready var ray_left = $RayLeft
@onready var ray_right = $RayRight
@onready var animated_sprite = $AnimatedSprite2D
@onready var body: CollisionShape2D = $Killzone/Body
@onready var tail: CollisionShape2D = $Killzone/Tail
@onready var floor_detection: RayCast2D = $FloorDetection
@onready var attack_col: CollisionShape2D = $Killzone/Attack
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Hurtbox = $Hurtbox

var on_floor: bool = true
var max_anim_cycles: int = 3
var anim_cycles: int = 0
var walk_frames: int = 7
var attack_frames: int = 6
var current_frame: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	floor_detection.floor_changed.connect(_floor_changed)
	health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attack_col.disabled = !(sprite.animation == "Attack" && sprite.frame > 1)

	if (ray_right.is_colliding()) || (ray_left.is_colliding()) || !on_floor:
		change_dir()
		update_child_position(tail)
		update_child_position_reverse(floor_detection)
		update_child_position_reverse(attack_col)
		on_floor = true

	if self.health:
		manage_transitions()
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

func update_child_position_reverse(node: Node2D):
	# left
	if animated_sprite.flip_h:
		# Flip the child's X position relative to the parent’s origin
		node.position.x = abs(node.position.x)
	# right
	else:
		# Ensure the child node's position is set correctly when not flipped
		node.position.x = -abs(node.position.x)

func change_dir() -> void:
	direction *= -1
	animated_sprite.flip_h = !animated_sprite.flip_h

func _floor_changed(is_on_floor: bool):
	on_floor = is_on_floor

func take_damage(value: int) -> void:
	self.health = clamp(self.health - value, 0, max_health)
	if !self.health:
		die()

func die():
	sprite.play("Die")
	$Sfx/Die.play()
	body.disabled = true
	tail.disabled = true
	attack_col.disabled = true
	hurtbox.monitoring = false

	await sprite.animation_finished
	queue_free()

func manage_transitions() -> void:
	match sprite.animation:
		"Walk":
			if (sprite.frame >= walk_frames - 1):
				anim_cycles += 1

		"Attack":
			if (sprite.frame >= attack_frames - 1):
				anim_cycles = 0
		_:
			pass

	if anim_cycles > 4:
		sprite.play("Attack")
		speed = 0
	else:
		sprite.play("Walk")
		speed = max_speed
