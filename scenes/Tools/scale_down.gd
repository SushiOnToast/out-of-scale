extends Tool

func action(body_part: Sprite2D):
	#print(body_part.scale)
	#if body_part.scale == Vector2.ONE:
		#print("success")
	#else:
	if body_part.scale - Vector2(0.1, 0.1) > Vector2(0.1, 0.1):
		body_part.scale -= Vector2(0.1, 0.1)
		trigger_minigame.emit(randi_range(0, 3))

	else:
		print("Limit reached")
