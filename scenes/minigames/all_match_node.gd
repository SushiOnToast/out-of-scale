extends Sprite2D

var textures = [
	preload("res://graphics/UI/minigames/all_match/icon_1.png"),
	preload("res://graphics/UI/minigames/all_match/icon_2.png"),
	preload("res://graphics/UI/minigames/all_match/icon_3.png"),
	preload("res://graphics/UI/minigames/all_match/icon_4.png"),
]

var target_texture
var index = randi_range(0, 3)
var active = false
var solved = false

func _process(_delta: float) -> void:
	texture = textures[index]
	solved = true if texture == target_texture else false
	if Input.is_action_just_pressed("use") and active:
		index += 1
		if index > 3:
			index = 0
	
func _on_area_2d_mouse_entered() -> void:
	active = true

func _on_area_2d_mouse_exited() -> void:
	active = false
