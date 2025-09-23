extends Control

@onready var main_btns: VBoxContainer = $MainBtns
@onready var options: Panel = $Options
@onready var bg: Panel = $Bg

@onready var start_btn: Button = $MainBtns/StartBtn
@onready var options_btn: Button = $MainBtns/OptionsBtn
@onready var quit_btn: Button = $MainBtns/QuitBtn
var selected_btn: Button = null

func _ready() -> void:
	main_btns.visible = true
	options.visible = false
	bg.visible = true
	$Bg/Cock.visible = true
	
	selected_btn = start_btn
	selected_btn.grab_focus()

func _on_start_btn_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_options_btn_pressed() -> void:
	main_btns.visible = false
	options.visible = true
	$Bg/Cock.visible = false

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_back_btn_pressed() -> void:
	_ready()
