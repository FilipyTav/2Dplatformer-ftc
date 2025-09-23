extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
# -1: left, 1: right
var direction: int = 1

var info_to_r: Dictionary = {
	"rotation": -25,
	"scale.x": 1,
	}
var info_to_l: Dictionary = {
	"rotation": 25,
	"scale.x": -1,
	}

# -1 = left , 1 = right
func set_info(dir: int):
	if !(dir == 1 || dir == -1):
		return

	var info: Dictionary = {}
	if dir > 0:
		info = info_to_r
	elif dir < 0:
		info = info_to_l

	sprite.rotation = deg_to_rad(info["rotation"])
	sprite.scale.x = info["scale.x"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_info(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = sprite.scale.x
	if Input.is_action_just_pressed("attack"):
		self.show()
		if direction > 0:
			anim_player.play("slashtor")
		elif direction < 0:
			anim_player.play("slashtol")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slashtor" || anim_name == "slashtol":
			self.hide()
