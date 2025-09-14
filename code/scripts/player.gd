extends CharacterBody2D

@export_range(0.0, 1.0) var friction = 0.25
@export_range(0.0 , 1.0) var acceleration = 0.25
@export var speed = 200
@export var jump_speed = -300

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer

var coyote_frames: int = 6  # How many in-air frames to allow jumping
var coyote: bool = false  # Track whether it's coyote time or not
var last_floor: bool = false  # Last frame's on-floor state
var jumping: bool = false

# To sync with rigid nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	coyote_timer.wait_time = coyote_frames / 60.0

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	get_input(delta)

	move_and_slide()

	manage_visuals(int(velocity.x))

	if (is_on_floor() and jumping):
		jumping = false

	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		coyote_timer.start()

	last_floor = is_on_floor()


func _on_coyote_timer_timeout() -> void:
	coyote = false

func get_input(delta: float) -> void:
	### Movements

	# Get input direction - -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")

	if (direction):
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	# Handle jump
	if (jumping):
		animated_sprite.play("jump")

	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		jumping = true
		velocity.y += jump_speed


func manage_visuals(direction: int):
	# Flip sprite
	if (direction > 0):
		animated_sprite.flip_h = false
	elif (direction < 0):
		animated_sprite.flip_h = true

	# Play animation
	if (is_on_floor()):
		if (!direction):
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
