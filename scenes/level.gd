extends Node2D
var minigame_scene = preload("res://scenes/minigame.tscn")
var entity_scene = preload("res://scenes/entity/entity.tscn")

@onready var ui_layer = $UI
var player_original_parent: Node = null
var current_entity: CharacterBody2D

#func _ready() -> void:
	#if current_entity.shape is RectangleShape2D:
		#print(current_entity.shape.size.x)
		#$UI/TextureRect.size = current_entity.shape.size
		#$UI/TextureRect.scale = Global.entity_scale
		#
		#
	#$UI/TextureRect.texture = current_entity.outline_texture
	
func _ready() -> void:
	create_new_entity()

func create_new_entity():
	current_entity = entity_scene.instantiate() as CharacterBody2D
	current_entity.position = Vector2(160, 90)
	current_entity.scale = Global.entity_scale
	$Entities.add_child(current_entity)

func trigger_minigame(target: Sprite2D, type: int):
	Global.minigame_mode = true

	var minigame = minigame_scene.instantiate()
	ui_layer.add_child(minigame)

	var player_cursor = get_tree().get_first_node_in_group("PlayerCursor")
	player_original_parent = player_cursor.get_parent()
	player_original_parent.remove_child(player_cursor)
	minigame.add_child(player_cursor)
	
	var minigame_copy = target.duplicate()
	minigame_copy.centered = true
	minigame_copy.offset = Vector2.ZERO
	minigame_copy.position = Vector2(160, 90)
	minigame_copy.scale = Vector2(3.0, 3.0)  # reset scale so it displays at a consistent size regardless of how shrunk/stretched the original is
	minigame.add_child(minigame_copy)
	minigame.start(minigame_copy, 0)
	
func _on_scale_up_trigger_minigame(target: Sprite2D, type: int) -> void:
	trigger_minigame(target, type)
	
func _on_scale_down_trigger_minigame(target: Sprite2D, type: Variant) -> void:
	trigger_minigame(target, type)

func _on_confirm_button_pressed() -> void:
	if current_entity:
		if current_entity.check_cured():
			print("success")
			current_entity.queue_free()
			create_new_entity()
		else:
			print("try again")
