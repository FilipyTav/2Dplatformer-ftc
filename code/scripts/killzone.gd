extends Area2D

@onready var timer: Timer = $Timer
@onready var dmg_cd: Timer = $DmgCooldown

# Enemy stats
@export var damage: int = 1
@export var attack_cooldown: float = 1.0  # Time between each attack

signal dealt_damage(value)

func _ready() -> void:
	dmg_cd.wait_time = attack_cooldown

func _on_body_entered(body:Node2D) -> void:
	# Make sure the body is the player (check its type)
	if body.is_in_group("player"):  # Make sure player is in the "player" group
		if !dmg_cd.is_stopped():
			return

		deal_damage(body)

# Function to deal damage
func deal_damage(body: Node) -> void:
	# You can connect this to a signal or directly affect the player's health
	if body.has_method("take_damage"):
		body.take_damage(damage)

	# Emit a signal that damage has been dealt (if needed elsewhere)
	emit_signal("dealt_damage", damage)
	dmg_cd.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_dmg_cooldown_timeout() -> void:
	pass
