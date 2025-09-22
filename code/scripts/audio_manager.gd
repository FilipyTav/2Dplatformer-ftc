extends AudioStreamPlayer

@export var sound_files: Array[AudioStream] = []
@export var audio_bus: String = ""

@onready var player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	set_bus_on_audio_players(self, audio_bus)

func play_random_sound():
	if sound_files.size() == 0:
		return

	var random_sound = sound_files[randi() % sound_files.size()]
	player.stream = random_sound
	player.play()

# Set bus on all AudioStreamPlayers inside a node
func set_bus_on_audio_players(root_node: Node, bus_name: String) -> void:
	if root_node is AudioStreamPlayer or root_node is AudioStreamPlayer2D or root_node is AudioStreamPlayer3D:
		root_node.bus = bus_name

	for child in root_node.get_children():
		# If child is an AudioStreamPlayer or AudioStreamPlayer2D/3D
		if child is AudioStreamPlayer or child is AudioStreamPlayer2D or child is AudioStreamPlayer3D:
			child.bus = bus_name

		# Recursively do the same for child's children
		if child.get_child_count() > 0:
			set_bus_on_audio_players(child, bus_name)
