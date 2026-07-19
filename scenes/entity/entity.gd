extends CharacterBody2D
@export var outline_texture : Texture
var body_parts : Array
var shape

func _ready() -> void:
	body_parts = find_children("*", "Area2D")
	shape = $CollisionShape2D.shape

	var shuffled_parts = body_parts.duplicate()
	shuffled_parts.shuffle()
	var count = clamp(Global.parts_to_modify, 1, body_parts.size())
	for i in range(count):
		var part = shuffled_parts[i] as Area2D
		var random_scale = snappedf([randf_range(0.5, 0.8), randf_range(1.2, 1.5)].pick_random(), 0.1)
		part.get_parent().scale = Vector2(random_scale, random_scale)

func check_cured() -> bool:
	var cured = true
	for body_part in body_parts:
		if not body_part.get_parent().scale.is_equal_approx(Vector2(1.0, 1.0)):
			cured = false
	return cured
