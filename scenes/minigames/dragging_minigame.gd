extends Node2D
var active = false
@export var padding: Vector2 = Vector2(90, 50)
@export var reposition_duration: float = 0.25
signal minigame_finished()
var successes = 0
var was_dropped_on_target = false

func _process(_delta: float) -> void:
	var dropped_on_target = active and !$DragObject.active and $DragObject.hover
	if dropped_on_target and not was_dropped_on_target:
		_move_drag_area_to(get_random_screen_position())
		successes += 1
		$TextureRect.hide()
		$Label.hide()
		if successes >= 5:
			minigame_finished.emit()
	was_dropped_on_target = dropped_on_target

func _move_drag_area_to(new_position: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property($DragArea, "global_position", new_position, reposition_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func get_random_screen_position() -> Vector2:
	var viewport_size = get_viewport_rect().size
	var x = randf_range(padding.x, viewport_size.x - padding.x)
	var y = randf_range(padding.y, viewport_size.y - padding.y)
	return Vector2(x, y)

func _on_area_2d_mouse_entered() -> void:
	active = true
func _on_area_2d_mouse_exited() -> void:
	active = false
