extends CharacterBody2D

const SPEED:float = 200.0
const JUMP_VEL:float = -300.0

# To sync with rigid nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += JUMP_VEL

	# Get input direction
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
