extends CharacterBody2D

@export var damage: int = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _on_hitbox_body_entered(body:Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(self.damage)
