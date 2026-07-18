extends Tool

const MIN_SCALE := Vector2(0.2, 0.2)

func action(body_part: Sprite2D):
	var new_scale = body_part.scale - Vector2(0.1, 0.1)
	new_scale = new_scale.clamp(MIN_SCALE, Vector2.INF)

	if new_scale == body_part.scale:
		print("Limit reached")
	else:
		body_part.scale = new_scale
		Global.current_clicks += 1
		if Global.current_clicks == Global.clicks_between_minigame:
			Global.current_clicks = 0
			trigger_minigame.emit(randi_range(0, 2))
