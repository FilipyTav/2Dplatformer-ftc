extends Node

@onready var score_label: Label = $"../Labels/ScoreLabel"
@onready var options: Panel = $"../UI/Options"

var score: int = 0

func _ready() -> void:
	options.hide()
	var quit_btn = options.get_node("BackBtn")
	quit_btn.text = "Quit"
	quit_btn.connect("pressed", self._on_quit_btn_pressed)

func add_point() -> void:
	score += 1
	score_label.text = "Poins: " + str(score)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		options.hide() if options.visible else options.show()
		get_tree().paused = !get_tree().paused

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
