extends Node

@onready var _anim_player: AnimationPlayer = $AnimationPlayer

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
@onready var track_current: AudioStreamPlayer = $Current
@onready var track_next: AudioStreamPlayer = $Next


# crossfades to a new audio stream
func crossfade_to(audio_stream: AudioStream) -> void:
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if track_current.playing and track_next.playing:
		return

	# The `playing` property of the stream players tells us which track is active.
	# If it's track two, we fade to track one, and vice-versa.
	if track_next.playing:
		track_current.stream = audio_stream
		track_current.play()
		_anim_player.play("FadeToCurrent")
	else:
		track_next.stream = audio_stream
		track_next.play()
		_anim_player.play("FadeToNext")
