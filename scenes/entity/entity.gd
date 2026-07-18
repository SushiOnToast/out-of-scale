extends CharacterBody2D
@export var outline_texture : Texture
@onready var body_parts = [$Head/Area2D, $Torso/Area2D, $Torso/RightLeg/Area2D, $Torso/RightArm/Area2D, $Torso/LeftLeg/Area2D, $Torso/LeftArm/Area2D]
var shape

func _ready() -> void:
	shape = $CollisionShape2D.shape

	var shuffled_parts = body_parts.duplicate()
	shuffled_parts.shuffle()

	var count = clamp(Global.parts_to_modify, 1, body_parts.size())

	for i in range(count):
		var part = shuffled_parts[i] as Area2D
		var random_scale = snappedf([randf_range(0.5, 0.8), randf_range(1.5, 3)].pick_random(), 0.1)
		part.get_parent().scale = Vector2(random_scale, random_scale)

func check_cured() -> bool:
	var cured = true
	for body_part in body_parts:
		if not body_part.get_parent().scale.is_equal_approx(Vector2(1.0, 1.0)):
			cured = false
	return cured
