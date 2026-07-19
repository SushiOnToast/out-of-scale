extends CenterContainer

signal minigame_finished()

@onready var target_display = $Node2D/TextureRect

func _ready() -> void:
	var rand_index = randi_range(0, 3)
	for node in get_tree().get_nodes_in_group("AllMatchNodes"):
		node.target_texture = node.textures[rand_index]
	
	target_display.texture = get_tree().get_first_node_in_group("AllMatchNodes").target_texture

func check_matched():
	var matched = true
	for node in get_tree().get_nodes_in_group("AllMatchNodes"):
		if !node.solved:
			matched = false
			
	return matched
	
func _process(_delta: float) -> void:
	if check_matched():
		minigame_finished.emit()
		queue_free()
