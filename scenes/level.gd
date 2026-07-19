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

var hint_cooldown_duration: float = 10.0
var hint_show_duration: float = 1.25
var hint_max_alpha: float = 0.4
var hint_cooldown_remaining: float = 0.0

var entity_base_position := Vector2(160, 80)
var entity_slide_duration: float = 0.4
var entity_exit_offset := Vector2(400, 0)
var entity_enter_offset := Vector2(-400, 0)
var entity_transition_gap: float = 0.3

@onready var sfx_players: Array[AudioStreamPlayer] = [$SFXPlayer1, $SFXPlayer2]
var next_player_index = 0

var success_sound = preload("res://audio/sfx/success.wav")
var failed_sound = preload("res://audio/sfx/failure.wav")
var scan_sound = preload("res://audio/sfx/scan.wav")
var minigame_start = preload("res://audio/sfx/minigame_start.wav")
var minigame_end = preload("res://audio/sfx/minigame_end.wav")
var new_round = preload("res://audio/sfx/new_round.wav")

func _ready() -> void:
	show_initial_round_screen()
	Global.start_new_round()
	create_new_entity(false)

func _process(delta: float) -> void:
	if Global.round_active:
		Global.time_remaining -= delta
		update_timer_display()
		if Global.time_remaining <= 0:
			on_round_failed()

	_update_hint_cooldown(delta)
	

func play_sfx(sound: AudioStream) -> void:
	var player = sfx_players[next_player_index]
	player.stream = sound
	player.play()
	next_player_index = (next_player_index + 1) % sfx_players.size()

func create_new_entity(animate_in: bool = true):
	current_entity = entity_scenes.pick_random().instantiate() as CharacterBody2D
	current_entity.scale = Global.entity_scale
	$Entities.add_child(current_entity)

	if animate_in:
		current_entity.position = entity_base_position + entity_enter_offset
		var tween = create_tween()
		tween.tween_property(current_entity, "position", entity_base_position, entity_slide_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		current_entity.position = entity_base_position

func transition_to_next_entity() -> void:
	var old_entity = current_entity
	current_entity = null

	var tween = create_tween()
	tween.tween_property(old_entity, "position", entity_base_position + entity_exit_offset, entity_slide_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): old_entity.queue_free())
	tween.tween_interval(entity_transition_gap)
	tween.tween_callback(func(): create_new_entity())

func update_timer_display() -> void:
	$UI/TimerLabel.text = "Time: %d" % ceil(Global.time_remaining)
	$UI/ScoreLabel.text = "%d / %d cured" % [Global.patients_cured, Global.patients_required]
	$UI/RoundNumber.text = "Wave %d" % (Global.rounds_completed + 1)
	
func on_round_failed() -> void:
	Global.round_active = false
	print("Time's up! Cured: ", Global.patients_cured, " / ", Global.patients_required)
	get_tree().change_scene_to_file("res://scenes/UI/game_over.tscn")

func on_round_success() -> void:
	Global.round_active = false
	Global.rounds_completed += 1
	print("Wave complete! Recieving wave ", Global.rounds_completed + 1)
	show_round_screen()

func _on_confirm_button_pressed() -> void:
	if current_entity and Global.round_active:
		if current_entity.check_cured():
			print("success")
			play_sfx(success_sound)
			Global.patients_cured += 1
			hint_cooldown_remaining = 0.0
			$UI/HintButton.disabled = false
			$UI/HintButton.text = "Scan"
			if Global.patients_cured >= Global.patients_required:
				current_entity.queue_free()
				current_entity = null
				on_round_success()
			else:
				transition_to_next_entity()
		else:
			play_sfx(failed_sound)
			print("try again")

func show_initial_round_screen() -> void:
	var round_screen = $"UI/Round Screen"
	var round_label = $"UI/Round Screen/RoundLabel"
	
	play_sfx(new_round)
	round_label.text = "Wave %d" % (Global.rounds_completed + 1)
	round_screen.visible = true
	round_screen.modulate.a = 1.0
	round_screen.scale = Vector2.ONE

	var tween = create_tween()
	tween.tween_interval(1.2)
	tween.tween_property(round_screen, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): round_screen.visible = false)

func show_round_screen() -> void:
	var round_screen = $"UI/Round Screen"
	var round_label = $"UI/Round Screen/RoundLabel"
	
	play_sfx(new_round)
	round_label.text = "Wave %d" % (Global.rounds_completed + 1)
	round_screen.visible = true
	round_screen.modulate.a = 0.0
	round_screen.scale = Vector2(0.8, 0.8)

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(round_screen, "modulate:a", 1.0, 0.3)
	tween.tween_property(round_screen, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.chain().tween_interval(1.2)

	tween.chain().tween_callback(func():
		Global.start_new_round()
		create_new_entity(false)
	)

	tween.chain().tween_property(round_screen, "modulate:a", 0.0, 0.3)
	tween.chain().tween_callback(func(): round_screen.visible = false)

func _on_hint_button_pressed() -> void:
	if hint_cooldown_remaining > 0:
		return

	hint_cooldown_remaining = hint_cooldown_duration
	play_hint_animation()

func _update_hint_cooldown(delta: float) -> void:
	if hint_cooldown_remaining > 0:
		hint_cooldown_remaining -= delta
		$UI/HintButton.disabled = true
		$UI/HintButton.text = "Scan (%d)" % ceil(hint_cooldown_remaining)
	else:
		hint_cooldown_remaining = 0.0
		$UI/HintButton.disabled = false
		$UI/HintButton.text = "Scan"

func play_hint_animation() -> void:
	if not current_entity:
		return
	
	play_sfx(scan_sound)
	var outline_sprite = current_entity.outline
	var tween = create_tween()
	tween.tween_property(outline_sprite, "modulate:a", hint_max_alpha, 0.2)
	tween.tween_interval(hint_show_duration)
	tween.tween_property(outline_sprite, "modulate:a", 0.0, 0.2)

func trigger_minigame(type: int):
	Global.minigame_mode = true
	play_sfx(minigame_start)
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
	play_sfx(minigame_end)
	minigame_instance.remove_child(player_cursor)
	player_original_parent.add_child(player_cursor)
	minigame_instance.queue_free()

func _on_scale_up_trigger_minigame(type: int) -> void:
	trigger_minigame(type)

func _on_scale_down_trigger_minigame(type: int) -> void:
	trigger_minigame(type)
