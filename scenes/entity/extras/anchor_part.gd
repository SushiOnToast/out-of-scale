extends Sprite2D
var last_scale := Vector2.ONE

func _ready() -> void:
	last_scale = scale

func _process(_delta: float) -> void:
	if scale != last_scale:
		var delta_ratio := scale / last_scale
		for child in get_children():
			if child is Node2D:
				var new_scale = child.scale / delta_ratio
				new_scale.x = snappedf(new_scale.x, 0.1)
				new_scale.y = snappedf(new_scale.y, 0.1)
				child.scale = new_scale
		last_scale = scale
