extends Node2D

@export var max_health: int = 1
@export var damage: int = 1

var health: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func heal(value: int):
	self.health = clamp(health + value, 0, max_health)

func take_damage(value: int):
	self.health = clamp(health - value, 0, max_health)

	if !self.health:
		die()

func die() -> void:
	pass
