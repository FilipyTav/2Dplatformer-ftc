extends CharacterBody2D

@export_range(0.0, 1.0) var friction = 0.25
@export_range(0.0 , 1.0) var acceleration = 0.25
@export var speed = 180
@export var jump_speed = -300
@export var max_health: int = 3

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashCooldown
@onready var ghost_timer: Timer = $DashGhost/GhostTimer
@onready var dash_particles: GPUParticles2D = $DashGhost/Particles
@onready var atk_hitbox: Area2D = $Attack
@onready var sfx: Node2D = $Sfx
@onready var collision_shape_2d: CollisionShape2D = $Attack/CollisionShape2D

var ghost_node: Resource = preload("res://scenes/ghost.tscn")
var coyote_frames: int = 6  # How many in-air frames to allow jumping
var coyote: bool = false  # Track whether it's coyote time or not
var last_floor: bool = false  # Last frame's on-floor state
var jumping: bool = false
var health = max_health
var can_change_anim: bool = true

# Multiply by speed
@export var dash_speed: float = 15
var dash_duration: float = .4
var is_dashing: bool = false

var dash_cd: float = .6
var can_dash: bool = true

var last_dir: float = 1

var grappling: bool = false
var attacking: bool = false

# To sync with rigid nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var atk_frames: int = 4

func _ready() -> void:
	coyote_timer.wait_time = coyote_frames / 60.0
	dash_timer.wait_time = dash_duration

	ghost_timer.wait_time = dash_duration / 6
	dash_cooldown.wait_time = dash_cd

	$UI/HealthBar.populate(max_health)
	$UI/DashButton.cooldown = dash_cd
	# It gets in the way in the editor
	$UI.visible = true
	collision_shape_2d.disabled = true

func _process(delta: float) -> void:
	grappling = $Chain.launched

func _physics_process(delta: float) -> void:
	if !is_on_floor() && !grappling:
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
	if !grappling:
		handle_dash()

		# Get input direction - -1, 0, 1
		var direction = Input.get_axis("move_left", "move_right")

		# Moviment on x axis
		if is_dashing:
			velocity.x = lerp(velocity.x, last_dir * speed * dash_speed, acceleration)
		elif direction:
			last_dir = direction
			velocity.x = lerp(velocity.x, direction * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)

	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote or grappling):
		jumping = true
		$Chain.launched = false
		velocity.y += jump_speed
		manage_sounds()

	if Input.is_action_just_pressed("attack"):
		attacking = true
	if Input.is_action_just_released("attack"):
		attacking = false


func manage_visuals(direction: int):
	# Flip sprite
	if (direction > 0):
		animated_sprite.flip_h = false
	elif (direction < 0):
		animated_sprite.flip_h = true

	if (can_change_anim):
		if (is_dashing):
			animated_sprite.play("dash")
		elif (jumping && !grappling):
			animated_sprite.play("jump")
		elif (is_on_floor()):
			if (!direction):
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")

	update_child_position(atk_hitbox)
	if (animated_sprite.flip_h):
		atk_hitbox.scale.x = -1
	else:
		atk_hitbox.scale.x = 1

	if (attacking):
		animated_sprite.play("attack")
		if (animated_sprite.frame > 0):
			collision_shape_2d.disabled = false
		can_change_anim = false
		await animated_sprite.animation_finished
		can_change_anim = true
		collision_shape_2d.disabled = true


func manage_sounds():
	if (jumping):
		$Sfx/Jump.play()

func handle_dash():
	if Input.is_action_just_pressed("dash") and !is_dashing and can_dash:
		ghost_timer.start()
		is_dashing = true
		dash_timer.start()

		can_dash = false
		dash_cooldown.start()
		dash_particles.emitting = true

		dash_speed = 15

		$UI/DashButton.activate()
	else:
		dash_speed = 1

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	dash_particles.emitting = false
	ghost_timer.stop()

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func add_ghost():
	var ghost = ghost_node.instantiate()

	var sprite_size: Vector2 = $AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.frame).get_size()

	# Make ghost's position match the visual top-left of the original sprite
	var sprite_offset = Vector2(0, sprite_size.y / 8) if $AnimatedSprite2D.centered else Vector2.ZERO
	ghost.set_property(position - sprite_offset, $AnimatedSprite2D.scale)
	if (last_dir < 0):
		ghost.flip_h = true
	elif (last_dir > 0):
		ghost.flip_h = false

	get_tree().current_scene.add_child(ghost)

func _on_ghost_timer_timeout() -> void:
	add_ghost()

func heal(value: int):
	self.health += value
	# Make sure health doesn't go below 0
	self.health = clamp(health, 0, max_health)
	$UI/HealthBar.update_health(self.health)

func take_damage(value: int):
	self.health -= value
	# Make sure health doesn't go below 0
	self.health = clamp(health, 0, max_health)
	$UI/HealthBar.update_health(self.health)
	$Sfx/TakeDmg.play()

	if !self.health:
		die()

func die() -> void:
	$Sfx/Die.play()
	can_change_anim = false
	animated_sprite.play("death")
	await animated_sprite.animation_finished
	can_change_anim = true
	
	print(animated_sprite.animation)

	Engine.time_scale = .5
	get_tree().paused = false
	# await animated_sprite.animation_finished
	Engine.time_scale = 1
	get_tree().reload_current_scene()

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
