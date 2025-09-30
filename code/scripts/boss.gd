extends CharacterBody2D

@export var death_ray: PackedScene
@export var damage: int = 1
@export var atk_cd: float = 3

@onready var atk_timer: Timer = $AttackTimer
@onready var tilemap: Node2D = owner.find_child("TileMap")
@onready var origins: Node2D = tilemap.find_child("RayOrigins")

var ray_origins: Array[Marker2D]

func _ready() -> void:
	randomize()

	for point in origins.get_children():
		ray_origins.append(point)
		print(point.position)

	atk_timer.wait_time = atk_cd
	atk_timer.start()

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
	print("ATk")
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
