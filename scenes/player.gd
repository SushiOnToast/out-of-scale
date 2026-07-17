extends Area2D

var holding_texture = preload("res://graphics/characters/player/player_holding.png")
var idle_texture = preload("res://graphics/characters/player/player_idle.png")

var hover_item : CharacterBody2D
var current_item : CharacterBody2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func get_input():
	if Input.is_action_pressed("grab"):
		$Sprite2D.texture = holding_texture
	else:
		$Sprite2D.texture = idle_texture
		
	if Input.is_action_just_released("grab") and hover_item:
		if current_item:
			current_item = null
			print("item dropped")
		else:
			print("grabbed item")
			current_item = hover_item

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	position = mouse_pos
	get_input()
	
	if current_item:
		$Sprite2D.texture = holding_texture
		current_item.position = mouse_pos - Vector2(7.5, 7.5)

func _on_body_entered(body: CharacterBody2D) -> void:
	hover_item = body

func _on_body_exited(body: CharacterBody2D) -> void:
	hover_item = null
