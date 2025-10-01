extends Node

# Declare variables for the AudioStreamPlayer nodes
# var music_player_current: AudioStreamPlayer
# var music_player_next: AudioStreamPlayer

const tracks: Dictionary[String, String] = {
	"Entering": "res://assets/music/RoboCock Soundtrack Official/1. Pre Fase.mp3",
	"LevelLoop": "res://assets/music/RoboCock Soundtrack Official/2. Fase Looping.mp3",
	"EnterGym": "res://assets/music/RoboCock Soundtrack Official/3. RoboCock Entrando Na Quadra.mp3",
	"BossDialogue": "res://assets/music/RoboCock Soundtrack Official/4. Dialogo Pre Boos.mp3",
	"PreBoss": "res://assets/music/RoboCock Soundtrack Official/5. Pre Boss.mp3",
	"BossLoop": "res://assets/music/RoboCock Soundtrack Official/6. Boss Looping.mp3",
	"Final": "res://assets/music/RoboCock Soundtrack Official/7. Cut Scene Final.mp3"
	}

# References to the nodes in our scene
@onready var track1: AudioStreamPlayer2D = $Track1
@onready var track2: AudioStreamPlayer2D = $Track2
@onready var current: AudioStream

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var game_manager: Node = $"$../$GameManager"

func _ready() -> void:
	pass

# crossfades to a new audio stream
func crossfade_to(audio_stream: AudioStream) -> void:
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if track1.playing and track2.playing:
		return

	# The `playing` property of the stream players tells us which track is active.
	# If it's track two, we fade to track one, and vice-versa.
	# Next
	if track2.playing:
		track1.stream = audio_stream
		track1.stream.loop = true
		track2.stop()
		track1.play()

		anim_player.play("FadeTo1")
		current = track1.stream
	# Current
	else:
		track2.stream = audio_stream
		track2.stream.loop = true
		track1.stop()
		track2.play()

		anim_player.play("FadeTo2")
		current = track2.stream

func try_await(time: float):
	await get_tree().create_timer(time).timeout

func _on_tile_map_on_boss_area_entered(_body:Node2D) -> void:
	crossfade_to(load(tracks["EnterGym"]))

func stop():
	track1.stop()
	track2.stop()

func play(track: String) -> void:
	crossfade_to(load(tracks[track]))

func current_finish() -> void:
	await try_await(current.get_length())
