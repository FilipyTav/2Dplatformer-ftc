extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED:float = 200.0
const JUMP_VEL:float = -300.0

# To sync with rigid nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VEL

	# Get input direction - -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")

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

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
