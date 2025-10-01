extends Node2D

# @onready var video_player: VideoStreamPlayer = $UI/VideoStreamPlayer
var video_player: VideoStreamPlayer
var cutscenes: Array[String] = ["res://assets/cutscenes/cutscene_begin.ogv"]
var current_index: int = -1

signal playing_cutscene(value: bool)
signal video_finished()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("skip"):
		skip()

func play(index: int) -> void:
	current_index = index
	video_player = ($UI/VideoStreamPlayer)

	video_player.show()
	video_player.stream = load(cutscenes[index]) as VideoStreamTheora
	video_player.play()

	playing_cutscene.emit(true)

func skip() -> void:
	video_player = ($UI/VideoStreamPlayer)
	video_player.stop()
	video_player.hide()
	playing_cutscene.emit(false)
	video_finished.emit()

func _on_video_stream_player_finished() -> void:
	skip()
