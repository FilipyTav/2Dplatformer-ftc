extends Node2D

@export var speed: float = 200.0
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var direction: Vector2 = Vector2.ZERO
var damage: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player:
		direction = (player.global_position - global_position).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = (player.global_position - global_position).normalized()
	self.position += direction * speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)

	self.queue_free()
