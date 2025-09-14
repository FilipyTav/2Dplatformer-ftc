extends CharacterBody2D

@export_range(0.0, 1.0) var friction = 0.25
@export_range(0.0 , 1.0) var acceleration = 0.25
@export var speed = 200
@export var jump_speed = -300

@onready var animated_sprite = $AnimatedSprite2D

# To sync with rigid nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	### Movement

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_speed

	# Get input direction - -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")

	if (direction != 0):
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	### Visuals

	# Flip sprite
	if (direction > 0):
		animated_sprite.flip_h = false
	elif (direction < 0):
		animated_sprite.flip_h = true

	# Play animation
	if (is_on_floor()):
		if (direction == 0):
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	move_and_slide()
