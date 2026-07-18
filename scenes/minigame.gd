extends MarginContainer
signal end_minigame()
var active_game = null
var active_instance: Node = null
var all_match_minigame_scene = preload("res://scenes/minigames/all_match_minigame.tscn")
var dragging_minigame_scene = preload("res://scenes/minigames/dragging_minigame.tscn")
var cursor_minigame_scene = preload("res://scenes/minigames/cursor_minigame.tscn")

func start(type):
	match type:
		0: all_match_minigame()
		1: dragging_minigame()
		2: cursor_minigame()
		_: print("invalid minigame")

func all_match_minigame():
	active_game = 0
	active_instance = all_match_minigame_scene.instantiate()
	active_instance.minigame_finished.connect(_on_minigame_finished)
	$CenterContainer.add_child(active_instance)

func dragging_minigame():
	active_game = 1
	active_instance = dragging_minigame_scene.instantiate()
	active_instance.minigame_finished.connect(_on_minigame_finished)
	$CenterContainer.add_child(active_instance)

func cursor_minigame():
	active_game = 2
	active_instance = cursor_minigame_scene.instantiate()
	active_instance.minigame_finished.connect(_on_minigame_finished)
	$CenterContainer.add_child(active_instance)

func _on_minigame_finished() -> void:
	active_game = null
	if active_instance:
		active_instance.queue_free()
		active_instance = null
	end_minigame.emit()
