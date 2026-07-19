extends Control

var visible_characters = 0
var score_active = false

func _ready() -> void:
	$Score.text = "Cured: " + str(Global.patients_cured) + " / " + str(Global.patients_required)
	
	var tween = create_tween()
	tween.tween_property($GameOverLabel, "modulate:a", 1, 1)
	tween.tween_interval(0.5)
	tween.tween_callback(func(): score_active = true)
	tween.tween_callback(func(): $RetryButton.show())
	tween.tween_callback(func(): $MenuButton.show())
	tween.tween_interval(2.0)
	tween.tween_property($RetryButton, "modulate:a", 1, 0.5)
	tween.tween_property($MenuButton, "modulate:a", 1, 0.5)
	tween.tween_callback(func(): $Player.show())
	tween.tween_property($Player, "modulate:a", 1, 0.5)
	
func _process(delta: float) -> void:
	if score_active:
		if $Score.visible_ratio < 1:
			$Score.visible_ratio += delta
		if visible_characters != $Score.visible_characters:
			visible_characters = $Score.visible_characters

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
