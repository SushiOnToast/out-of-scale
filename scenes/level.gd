extends Node2D
var minigame_scene = preload("res://scenes/minigame.tscn")
var entity_scenes = [
	preload("res://scenes/entity/entity_1.tscn"),
	#preload("res://scenes/entity/entity_2.tscn"),
	#preload("res://scenes/entity/entity_3.tscn"),
	#preload("res://scenes/entity/entity_4.tscn")
]

@onready var ui_layer = $UI
var player_original_parent: Node = null
var current_entity: CharacterBody2D

@export var hint_cooldown_duration: float = 15.0
@export var hint_show_duration: float = 1.5
var hint_cooldown_remaining: float = 0.0

func _ready() -> void:
	_show_initial_round_screen()

	Global.start_new_round()
	create_new_entity()
	$UI/TextureRect.modulate.a = 0.0

func _show_initial_round_screen() -> void:
	var round_screen = $"UI/Round Screen"
	var round_label = $"UI/Round Screen/RoundLabel"

	round_label.text = "Round %d" % (Global.rounds_completed + 1)
	round_screen.visible = true
	round_screen.modulate.a = 1.0   # fully opaque immediately, no fade-in needed
	round_screen.scale = Vector2.ONE

	var tween = create_tween()
	tween.tween_interval(1.2)  # hold before revealing the game
	tween.tween_property(round_screen, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): round_screen.visible = false)

func _process(delta: float) -> void:
	if Global.round_active:
		Global.time_remaining -= delta
		update_timer_display()
		if Global.time_remaining <= 0:
			on_round_failed()

	_update_hint_cooldown(delta)

func _update_hint_cooldown(delta: float) -> void:
	if hint_cooldown_remaining > 0:
		hint_cooldown_remaining -= delta
		$UI/HintButton.disabled = true
		$UI/HintButton.text = "Hint (%d)" % ceil(hint_cooldown_remaining)
	else:
		hint_cooldown_remaining = 0.0
		$UI/HintButton.disabled = false
		$UI/HintButton.text = "Hint"

func update_timer_display() -> void:
	$UI/TimerLabel.text = "Time: %d" % ceil(Global.time_remaining)
	$UI/ScoreLabel.text = "%d / %d cured" % [Global.patients_cured, Global.patients_required]

func on_round_failed() -> void:
	Global.round_active = false
	print("Time's up! Cured: ", Global.patients_cured, " / ", Global.patients_required)
	get_tree().change_scene_to_file("res://scenes/UI/game_over.tscn")

func create_new_entity():
	current_entity = entity_scenes.pick_random().instantiate() as CharacterBody2D
	current_entity.position = Vector2(160, 90)
	current_entity.scale = Global.entity_scale
	$Entities.add_child(current_entity)
	if current_entity.shape is RectangleShape2D:
		var collision_shape_node = current_entity.get_node("CollisionShape2D")
		var world_pos = collision_shape_node.global_position
		var raw_size = current_entity.shape.size * Global.entity_scale
		var even_size = Vector2(round(raw_size.x / 2.0) * 2.0, round(raw_size.y / 2.0) * 2.0)
		$UI/TextureRect.size = even_size
		$UI/TextureRect.position = world_pos - (even_size / 2.0)
	$UI/TextureRect.texture = current_entity.outline_texture
	$UI/TextureRect.modulate.a = 0.0  

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
	if current_entity and Global.round_active:
		if current_entity.check_cured():
			print("success")
			Global.patients_cured += 1
			current_entity.queue_free()
			if Global.patients_cured >= Global.patients_required:
				on_round_success()
			else:
				create_new_entity()
		else:
			print("try again")

func on_round_success() -> void:
	Global.round_active = false
	Global.rounds_completed += 1
	print("Round complete! Moving to round ", Global.rounds_completed + 1)
	show_round_screen()

func show_round_screen() -> void:
	var round_screen = $"UI/Round Screen"
	var round_label = $"UI/Round Screen/RoundLabel"

	round_label.text = "Round %d" % (Global.rounds_completed + 1)

	round_screen.visible = true
	round_screen.modulate.a = 0.0
	round_screen.scale = Vector2(0.8, 0.8)

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(round_screen, "modulate:a", 1.0, 0.3)
	tween.tween_property(round_screen, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.chain().tween_interval(1.2)  # hold fully visible

	# do the actual round setup while the screen still fully covers everything
	tween.chain().tween_callback(func():
		Global.start_new_round()
		create_new_entity()
	)

	tween.chain().tween_property(round_screen, "modulate:a", 0.0, 0.3)
	tween.chain().tween_callback(func(): round_screen.visible = false)

func _on_hint_button_pressed() -> void:
	if hint_cooldown_remaining > 0:
		return  

	hint_cooldown_remaining = hint_cooldown_duration
	play_hint_animation()

func play_hint_animation() -> void:
	var tween = create_tween()
	tween.tween_property($UI/TextureRect, "modulate:a", 1.0, 0.2)  
	tween.tween_interval(hint_show_duration)                         
	tween.tween_property($UI/TextureRect, "modulate:a", 0.0, 0.4)   
