extends Node2D
var active = false
@export var padding: float = 40.0
signal minigame_finished()

var successes = 0

func _process(delta: float) -> void:
	if active and !$DragObject.active and $DragObject.hover:
		$DragArea.position = get_random_screen_position()
		successes += 1
	
	if successes >= 5:
		minigame_finished.emit()

func get_random_screen_position() -> Vector2:
	var viewport_size = get_viewport_rect().size
	var x = randf_range(padding, viewport_size.x - padding)
	var y = randf_range(padding, viewport_size.y - padding)
	return Vector2(x, y)

func _on_area_2d_mouse_entered() -> void:
	active = true
func _on_area_2d_mouse_exited() -> void:
	active = false
