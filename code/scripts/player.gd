extends CharacterBody2D

@export_range(0.0, 1.0) var friction = 0.25
@export_range(0.0 , 1.0) var acceleration = 0.25
@export var speed = 200
@export var jump_speed = -300

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var dash_timer = $DashTimer

var coyote_frames: int = 6  # How many in-air frames to allow jumping
var coyote: bool = false  # Track whether it's coyote time or not
var last_floor: bool = false  # Last frame's on-floor state
var jumping: bool = false

# Multiply by speed
@export var dash_speed: float = 15
var is_dashing: bool = false

var last_dir: float = 0

# To sync with rigid nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	coyote_timer.wait_time = coyote_frames / 60.0
	dash_timer.wait_time = .4

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

	# Dash
	if Input.is_action_just_pressed("dash") and !is_dashing:
		is_dashing = true
		dash_speed = 15
		dash_timer.start()
	else:
		dash_speed = 1

	if is_dashing:
		velocity.x = lerp(velocity.x, last_dir * speed * dash_speed, acceleration)
	elif direction:
		last_dir = direction
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		jumping = true
		velocity.y += jump_speed

	if Input.is_action_just_pressed("print"):
		print(last_dir)

	# Grappling Hook


func manage_visuals(direction: int):
	# Flip sprite
	if (direction > 0):
		animated_sprite.flip_h = false
	elif (direction < 0):
		animated_sprite.flip_h = true

	# Jump
	if (jumping):
		animated_sprite.play("jump")

	# Play animation
	if (is_on_floor()):
		if (!direction):
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")


func _on_dash_timer_timeout() -> void:
	is_dashing = false
