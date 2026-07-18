extends Area2D
var hovering := false
var current_body: Node2D = null


func _physics_process(_delta: float) -> void:
	hovering = false
	var still_in_range := false

	for body in get_overlapping_bodies():
		if "active" in body:
			hovering = true
			still_in_range = true
			current_body = body
			if body.active:
				body.target = get_parent()

	if not still_in_range and current_body != null:
		if current_body.target == get_parent():
			current_body.target = null
		current_body = null
