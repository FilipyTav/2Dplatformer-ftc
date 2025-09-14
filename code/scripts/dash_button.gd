extends TextureButton

class_name AbilityButton

@onready var time_label: Label = $Counter/Value
@onready var sweep: TextureProgressBar = $Sweep
@onready var timer: Timer = $Sweep/Timer

@export var cooldown: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disabled = true
	time_label.hide()
	sweep.value = 0
	sweep.texture_progress = texture_normal

	timer.wait_time = cooldown
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_label.text = "%3.1f" % timer.time_left
	sweep.value = int((timer.time_left / cooldown) * 100)

func _on_pressed() -> void:
	set_process(true)
	timer.start()
	time_label.show()

func _on_timer_timeout() -> void:
	sweep.value = 0
	time_label.hide()
	set_process(false)

func activate() -> void:
	set_process(true)
	timer.start()
	time_label.show()
