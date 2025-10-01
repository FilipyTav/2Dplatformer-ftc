extends Node

@onready var options: Panel = $"../UI/Options"
@onready var tile_map: Node2D = $"../Map/TileMap"
@onready var video_player: Node2D = $"../VideoPlayer"
var options_animplay: AnimationPlayer = null
static var cutscene0played: bool = false

var score: int = 0

func _ready() -> void:
	if (!cutscene0played):
		video_player.play(0)
		cutscene0played = true
	else:
		video_player.skip()


	options.hide()
	var menu_btn = options.get_node("BackBtn")
	menu_btn.text = "Menu"
	menu_btn.connect("pressed", self._on_menu_btn_pressed)
	options_animplay = options.get_node("AnimationPlayer")
	print("working????")

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


func _on_video_player_video_finished() -> void:
	pass # Replace with function body.
