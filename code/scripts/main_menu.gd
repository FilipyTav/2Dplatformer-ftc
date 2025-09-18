extends Control

@onready var main_btns: VBoxContainer = $MainBtns
@onready var options: Panel = $Options

func _ready() -> void:
	main_btns.visible = true
	options.visible = false

func _on_start_btn_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_options_btn_pressed() -> void:
	main_btns.visible = false
	options.visible = true

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_back_btn_pressed() -> void:
	_ready()
