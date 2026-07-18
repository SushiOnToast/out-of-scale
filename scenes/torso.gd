extends Sprite2D
var last_scale := Vector2.ONE

func _ready() -> void:
	last_scale = scale

func _process(_delta: float) -> void:
	if scale != last_scale:
		var delta_ratio := scale / last_scale
		for child in get_children():
			if child is Sprite2D:
				child.scale.x /= delta_ratio.x
				child.scale.y /= delta_ratio.y
		last_scale = scale
