extends Control


func _on_start_btn_pressed() -> void:
	print("Start game...")

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
