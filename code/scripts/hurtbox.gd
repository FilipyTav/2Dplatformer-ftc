class_name Hurtbox

extends Area2D

func _init() -> void:
	self.collision_layer = 0
	self.collision_mask = 1 << 5

func _ready() -> void:
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: Hitbox) -> void:
	if !hitbox:
		return
	print("Entered")

	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
