extends Area2D

@onready var manager = %GameManager
@onready var animation_player = $PickupAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body:Node2D) -> void:

	manager.add_point()
	print("+1 coin")
	animation_player.play("pickup")
