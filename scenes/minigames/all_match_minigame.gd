extends CenterContainer

signal minigame_finished()

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
