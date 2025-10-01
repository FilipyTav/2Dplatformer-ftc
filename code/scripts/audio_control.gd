extends HSlider

@export var audio_bus_name: String = ""
var audio_bus_id: int = 0

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	var lin = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_id))
	set_value_no_signal(lin)

func _on_value_changed(value: float) -> void:
	print(value)
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
