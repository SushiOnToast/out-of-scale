extends MarginContainer

signal end_minigame()

var active_game = null
var all_match_minigame_scene = preload("res://scenes/minigames/all_match_minigame.tscn")

func start(type):
	match type:
		0: all_match_minigame()
		_: print("invalid minigame")

func all_match_minigame():
	active_game = 0
	var all_match = all_match_minigame_scene.instantiate()
	all_match.minigame_finished.connect(_on_all_match_minigame_minigame_finished)
	$CenterContainer.add_child(all_match)

func _on_all_match_minigame_minigame_finished() -> void:
	if active_game == 0:
		active_game = null
		end_minigame.emit()
	
