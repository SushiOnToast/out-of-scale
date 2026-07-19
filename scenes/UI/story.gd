extends Control

var attention_visible_characters = 0
var attention_active = false
var text1_visible_characters = 0
var text1_active = false
var text2_visible_characters = 0
var text2_active = false

var nav_menu = false

func _ready() -> void:
	
	var tween = create_tween()
	tween.tween_property($Trigger, "modulate:a", 1, 0.5)
	tween.tween_interval(3)
	tween.tween_property($Trigger, "modulate:a", 0, 0.5)
	
	tween.tween_property($VHS, "modulate:a", 1, 2)
	tween.tween_interval(2)
	
	tween.tween_property($Control, "modulate:a", 0, 0.5)
	tween.tween_callback(func(): start_ambient_flicker() ) 
	
	tween.tween_interval(1)
	tween.tween_callback(func(): attention_active = true)
	tween.tween_interval(2)
	tween.tween_callback(func(): text1_active = true)
	tween.tween_interval(12)
	tween.tween_property($Text1, "modulate:a", 0, 0.2)
	tween.tween_callback(func(): text2_active = true)
	tween.tween_interval(17)
	
	tween.tween_property($Cover, "modulate:a", 1, 1)
	tween.tween_interval(3)
	tween.tween_callback(func(): nav_menu = true)

func _process(delta: float) -> void:
	if attention_active:
		typewriter($Attention, delta, attention_visible_characters)
	if text1_active:
		typewriter($Text1, delta, text1_visible_characters, 0.1)
	if text2_active:
		typewriter($Text2, delta, text2_visible_characters, 0.075)
		
	if nav_menu:
		get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
			
func typewriter(text: RichTextLabel, delta: float, visible_characters, multiplier:float = 1):
	if text.visible_ratio < 1:
		text.visible_ratio += multiplier * delta
	if visible_characters != text.visible_characters:
		visible_characters = text.visible_characters

func start_ambient_flicker() -> void:
	var flicker_tween = create_tween()
	flicker_tween.set_loops()
	flicker_tween.tween_property($Control, "modulate:a", 0.5, 0.2)
	flicker_tween.tween_property($Control, "modulate:a", 1.0, 0.2)
	flicker_tween.tween_interval(0.5)
