extends Node2D
var minigame_scene = preload("res://scenes/minigame.tscn")
var entity_scenes = [
	preload("res://scenes/entity/entity_1.tscn"),
	preload("res://scenes/entity/entity_2.tscn"),
	preload("res://scenes/entity/entity_3.tscn"),
	preload("res://scenes/entity/entity_4.tscn")
]

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
	current_entity = entity_scenes.pick_random().instantiate() as CharacterBody2D
	current_entity.position = Vector2(160, 90)
	current_entity.scale = Global.entity_scale
	$Entities.add_child(current_entity)

func trigger_minigame(type: int):
	Global.minigame_mode = true

	var minigame = minigame_scene.instantiate()
	ui_layer.add_child(minigame)

	var player_cursor = get_tree().get_first_node_in_group("PlayerCursor")
	player_original_parent = player_cursor.get_parent()
	player_original_parent.remove_child(player_cursor)
	minigame.add_child(player_cursor)
	minigame.start(type)
	
	minigame.end_minigame.connect(_on_minigame_ended.bind(minigame, player_cursor))

func _on_minigame_ended(minigame_instance: Node, player_cursor: Node) -> void:
	Global.minigame_mode = false

	minigame_instance.remove_child(player_cursor)
	player_original_parent.add_child(player_cursor)

	minigame_instance.queue_free()

func _on_scale_up_trigger_minigame(type: int) -> void:
	trigger_minigame(type)
	
func _on_scale_down_trigger_minigame(type: int) -> void:
	trigger_minigame(type)

func _on_confirm_button_pressed() -> void:
	if current_entity:
		if current_entity.check_cured():
			print("success")
			current_entity.queue_free()
			create_new_entity()
		else:
			print("try again")
