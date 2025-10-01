extends Control

@onready var main_btns: VBoxContainer = $MainBtns
@onready var options: Panel = $Options
@onready var bg: Panel = $Bg

@onready var start_btn: Button = $MainBtns/StartBtn
@onready var options_btn: Button = $MainBtns/OptionsBtn
@onready var quit_btn: Button = $MainBtns/QuitBtn
@onready var bgm: AudioStreamPlayer2D = $Bgm
var selected_btn: Button = null

func _ready() -> void:
	bg.show()
	selected_btn = start_btn
	hide_options()
	show_main()

	var back_btn = options.get_node("BackBtn")
	back_btn.connect("pressed", self._on_back_btn_pressed)

func _on_start_btn_pressed() -> void:
		bgm.stop()
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_options_btn_pressed() -> void:
	hide_main()
	show_options()

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_back_btn_pressed() -> void:
	hide_options()
	show_main()
	# get_tree().reload_current_scene()

func show_main() -> void:
	main_btns.show()
	$Bg/Cock.show()
	selected_btn.grab_focus()

func hide_main() -> void:
	main_btns.hide()
	$Bg/Cock.hide()

func show_options() -> void:
	options.get_node("AnimationPlayer").play("blur")
	options.show()

func hide_options() -> void:
	options.hide()
