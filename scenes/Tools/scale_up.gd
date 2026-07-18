extends Tool

const MAX_SCALE := Vector2(3.5, 3.5)

func action(body_part: Sprite2D):
	var new_scale = body_part.scale + Vector2(0.1, 0.1)
	new_scale = new_scale.clamp(Vector2.ZERO, MAX_SCALE)

	if new_scale == body_part.scale:
		print("Limit reached")
	else:
		body_part.scale = new_scale
		Global.current_clicks += 1
		if Global.current_clicks == Global.clicks_between_minigame:
			Global.current_clicks = 0
			trigger_minigame.emit(randi_range(0, 2))
