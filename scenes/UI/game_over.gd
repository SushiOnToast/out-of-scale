extends Control

func _ready() -> void:
	$Label/Score.text = "Cured: " + str(Global.patients_cured) + " / " + str(Global.patients_required)

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
