extends Control

func _on_start_button_pressed() -> void:
	$Player.queue_free()
	get_tree().change_scene_to_file("res://scenes/level.tscn")
