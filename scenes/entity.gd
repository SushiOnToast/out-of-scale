extends CharacterBody2D

func _ready() -> void:
	var body_parts = [$Head/Area2D, $Torso/Area2D, $Torso/RightLeg/Area2D, $Torso/RightArm/Area2D, $Torso/LeftLeg/Area2D, $Torso/LeftArm/Area2D]
	var part = body_parts.pick_random() as Area2D
	print(part.get_parent().scale)
	var random_scale = [randf_range(0.2, 0.5), randf_range(1.5, 3)].pick_random()
	part.get_parent().scale = Vector2(random_scale, random_scale)
	print(part.get_parent().scale)

#func _process(_delta: float) -> void:
	## if you still want to see hover states for debugging:
	#for part in [$Head/Area2D, $Torso/Area2D, $RightLeg/Area2D, $RightArm/Area2D, $LeftLeg/Area2D, $LeftArm/Area2D]:
		#print(part.name)
