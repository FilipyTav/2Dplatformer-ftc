extends Node

@onready var score_label: Label = $"../Labels/ScoreLabel"

var score: int = 0

func add_point() -> void:
	score += 1
	score_label.text = "Poins: " + str(score)

# TODO: make the options menu its own scene, and finish the pause functionality
