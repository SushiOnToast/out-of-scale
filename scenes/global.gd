extends Node
var minigame_mode = false
var entity_scale = Vector2(2.5, 2.5)
var clicks_between_minigame = 8
var current_clicks = 0
var parts_to_modify = 1

var patients_cured = 0
var patients_required = 5
var time_remaining = 180
var round_active = false
var rounds_completed = 0

func start_new_round() -> void:
	patients_cured = 0
	round_active = true

	var level = rounds_completed

	patients_required = 5 + int(sqrt(level) * 3)
	time_remaining = max(25.0, 60.0 - (level * 4.0))
	parts_to_modify = clamp(1 + int(level / 2.0), 1, 6) # 1 more every 2 rounds
	clicks_between_minigame = clamp(5 - int(level / 2.0), 2, 5)
