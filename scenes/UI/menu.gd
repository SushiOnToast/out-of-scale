extends Control

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($MenuScreen, "modulate:a", 1, 1.5)
	tween.tween_interval(1.5)
	tween.tween_property($Label1, "modulate:a", 1, 1)
	tween.tween_property($Label2, "modulate:a", 1, 1)
	tween.tween_interval(1)
	tween.tween_callback(func(): $StartButton.show())
	tween.tween_property($StartButton, "modulate:a", 1, 0.5)
	tween.tween_callback(func(): $Player.show())
	tween.tween_property($Player, "modulate:a", 1, 0.5)

func _on_start_button_pressed() -> void:
	$Player.queue_free()
	get_tree().change_scene_to_file("res://scenes/level.tscn")
