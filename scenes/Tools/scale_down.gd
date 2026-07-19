extends Tool
const MIN_SCALE := Vector2(0.2, 0.2)

var action_sound = preload("res://audio/sfx/scale_down.wav")
var limit = preload("res://audio/sfx/limit.wav")

func action(body_part: Sprite2D):
	var new_scale = body_part.scale - Vector2(0.1, 0.1)
	new_scale = new_scale.clamp(MIN_SCALE, Vector2.INF)

	if new_scale == body_part.scale:
		print("Limit reached")
		$AudioStreamPlayer.stream = limit
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stream = action_sound
		$AudioStreamPlayer.play()
		var tween = create_tween()
		tween.tween_property(body_part, "scale", new_scale, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

		Global.current_clicks += 1
		if Global.current_clicks == Global.clicks_between_minigame:
			Global.current_clicks = 0
			trigger_minigame.emit(randi_range(0, 2))
