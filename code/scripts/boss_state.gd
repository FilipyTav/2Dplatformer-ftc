extends Node2D
class_name State

@onready var debug: Label = owner.find_child("Debug")
@onready var player: CharacterBody2D = owner.get_parent().find_child("Player")
@onready var anim_player: AnimationPlayer = owner.find_child("AnimationPlayer")

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
