extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var damage: int = 1

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(self.damage)

func _on_stay_timeout() -> void:
	queue_free()
