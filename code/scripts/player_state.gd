extends Node2D
class_name PState

@onready var debug: Label = owner.find_child("Debug")
@onready var player: CharacterBody2D = $"../.."
@onready var anim_sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

func _ready() -> void:
	set_physics_process(false)

func enter() -> void:
	set_physics_process(true)

func exit() -> void:
	set_physics_process(false)

func transition():
	pass

func _physics_process(_delta: float) -> void:
	transition()
	debug.text = self.name
