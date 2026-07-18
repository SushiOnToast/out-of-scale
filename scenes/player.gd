extends Area2D

var holding_texture = preload("res://graphics/characters/player/player_holding.png")
var idle_texture = preload("res://graphics/characters/player/player_idle.png")

var minigame_texture = preload("res://graphics/characters/player/player_minigame.png")
var minigame_click_texture = preload("res://graphics/characters/player/player_minigame_click.png")

var hover_item : CharacterBody2D
var current_item : CharacterBody2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func get_input():
	if Global.minigame_mode:
		$Sprite2D.texture = minigame_click_texture if Input.is_action_pressed("use") else minigame_texture
		scale = Vector2(0.5, 0.5)
	else:
		$Sprite2D.texture = holding_texture if Input.is_action_pressed("grab") else idle_texture
		scale = Vector2.ONE
			
		if Input.is_action_just_released("grab") and hover_item:
			if current_item:
				current_item.active = false
				current_item = null
			else:
				current_item = hover_item
				current_item.active = true

func _process(_delta: float) -> void:
	if Global.minigame_mode:
		if current_item:
			current_item.active = false
			current_item = null
			$Sprite2D.texture = idle_texture
	
	get_input()
	
	var mouse_pos = get_global_mouse_position()
	position = mouse_pos
	
	if current_item:
		$Sprite2D.texture = holding_texture
		current_item.position = mouse_pos - Vector2(7.5, 7.5)

func _on_body_entered(body: CharacterBody2D) -> void:
	hover_item = body

func _on_body_exited(body: CharacterBody2D) -> void:
	hover_item = null
