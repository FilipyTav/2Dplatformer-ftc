extends CharacterBody2D

@export var death_ray: PackedScene
@export var projectile: PackedScene
@export var damage: int = 1
@export var atk_cd: float = 3
@export var max_health: int = 4
@export var activated: bool = false

@onready var atk_timer: Timer = $AttackTimer
@onready var tilemap: Node2D = owner.find_child("TileMap")
@onready var origins: Node2D = tilemap.find_child("RayOrigins")
@onready var health_bar: ProgressBar = $UI/ProgressBar
@onready var projectile_origin: Marker2D = $ProjectileOrigin
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var projectile_timer: Timer = $ProjectileTimer

var ray_origins: Array[Marker2D]
var health: int = 0

func _ready() -> void:
	randomize()
	health = max_health

	for point in origins.get_children():
		ray_origins.append(point)

	atk_timer.wait_time = atk_cd

func start() -> void:
	atk_timer.start()
	projectile_timer.start()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _on_hitbox_body_entered(body:Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(self.damage)


func _on_attack_timer_timeout() -> void:
	attack()

func attack() -> void:
	var rd_index: int = randi() % ray_origins.size()
	var ray_point: Marker2D = ray_origins[rd_index]
	var ray = death_ray.instantiate()

	ray.position = ray_point.position
	ray.scale.x = 30 # Some big number
	ray.scale.y = 3

	if (rd_index <= 1):
		ray.rotation += deg_to_rad(90)

	tilemap.add_child(ray)
	ray.anim_player.play("appear")

func take_damage(value: int):
	health = clamp(health - value, 0, max_health)
	health_bar.value = health
	
	if (self.health <= 0):
		die()

func die() -> void:
	animation_player.play("victory")
	await animation_player.animation_finished
	animation_player.play("disappear")

	self.queue_free()

func shoot_projectile() -> void:
	var proj = projectile.instantiate()
	proj.position = projectile_origin.position
	proj.scale = Vector2(8, 8)
	proj.speed = 300
	self.add_child(proj)

func _on_projectile_timer_timeout() -> void:
	shoot_projectile()


func _on_tile_map_on_boss_area_entered(body: Node2D) -> void:
	start()
