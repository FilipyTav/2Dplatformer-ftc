extends Node2D

@onready var enter_boss: Area2D = $AreaTriggers/EnterBoss
@onready var animation_player: AnimationPlayer = $Mid/AnimationPlayer
@onready var boss_door_anim: AnimationPlayer = $Mid/BossDoor/AnimationPlayer

signal on_enter_boss_entered(body: Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enter_boss_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animation_player.play("lighten")
		boss_door_anim.play("close")
		enter_boss.queue_free()
		on_enter_boss_entered.emit(body)
