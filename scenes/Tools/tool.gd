extends CharacterBody2D
class_name Tool

var active = false
var gravity = 200

var target: Sprite2D

signal trigger_minigame(type: int)

func apply_gravity(delta):
	velocity.y += gravity * delta

func _physics_process(delta: float) -> void:
	if !active:
		apply_gravity(delta)
	
	if Input.is_action_just_pressed("use") and active and target and !Global.minigame_mode:
		action(target)
		
	move_and_slide()

func action(body_part: Sprite2D):
	pass
