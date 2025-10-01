extends Node2D

@export var speed: float = 200.0

@onready var player: CharacterBody2D
@onready var boss: CharacterBody2D = get_parent()
@onready var sprite_anim: AnimatedSprite2D = $AnimatedSprite2D

var animations: Array[String] = ["projectile1", "projectile2"]

var direction: Vector2 = Vector2.ZERO
var damage: int = 1

var follow_player: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	player = get_tree().get_first_node_in_group("player")
	if player:
		direction = (player.global_position - global_position).normalized()
	sprite_anim.play(animations[randi() % animations.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (follow_player):
		direction = (player.global_position - self.global_position).normalized()
		self.position += direction * speed * delta
	else:
		direction = (boss.global_position - self.global_position).normalized()
		self.position += direction * speed * 2 * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)

	self.queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	var area_owner: Node2D = area.owner
	if (area_owner.is_in_group("player")):
		follow_player = false
		$Area2D.set_collision_mask_value(4, true)

	if (area_owner.is_in_group("boss")):
		if area_owner.has_method("take_damage"):
			area_owner.take_damage(damage)
		self.queue_free()
