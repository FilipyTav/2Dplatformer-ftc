extends Node2D

@export var max_health: int = 1
var health: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health

func heal(value: int):
	self.health = clamp(health + value, 0, max_health)

func take_damage(value: int):
	self.health = clamp(health - value, 0, max_health)
	print("Dmg: ", value)

	if !self.health:
		die()

func die() -> void:
	pass
