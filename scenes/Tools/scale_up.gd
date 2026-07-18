extends Tool

func action(body_part: Sprite2D):
	#if body_part.scale == Vector2.ONE:
		#print("success")
	
	body_part.scale += Vector2(0.1, 0.1)
	trigger_minigame.emit(0)
