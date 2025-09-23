class_name Hitbox

extends Area2D

@export var damage: int = 1

func _init() -> void:
	self.collision_layer = 5
	self.collision_mask = 0
