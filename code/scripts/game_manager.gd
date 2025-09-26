extends Node

@onready var options: Panel = $"../UI/Options"
var options_animplay: AnimationPlayer = null

var score: int = 0

func _ready() -> void:
	options.hide()
	var menu_btn = options.get_node("BackBtn")
	menu_btn.text = "Menu"
	menu_btn.connect("pressed", self._on_menu_btn_pressed)
	options_animplay = options.get_node("AnimationPlayer")

func add_point() -> void:
	score += 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		options.hide() if options.visible else options.show()
		options_animplay.play("blur") if options.visible else options_animplay.play_backwards("blur")

		get_tree().paused = !get_tree().paused

	if Input.is_action_just_pressed("slow"):
		Engine.time_scale = 1. if Engine.time_scale < 1. else .2

func _on_menu_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
