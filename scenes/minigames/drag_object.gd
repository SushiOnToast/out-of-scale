extends Sprite2D

var active = false
var hover = false

func _process(_delta: float) -> void:
	active = Input.is_action_pressed("use") and hover
	if active:
		position = get_global_mouse_position()
	
func _on_area_2d_mouse_entered() -> void:
	hover = true
	
func _on_area_2d_mouse_exited() -> void:
	hover = false
