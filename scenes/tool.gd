extends CharacterBody2D

var active = false
var gravity = 150

func apply_gravity(delta):
	velocity.y += gravity * delta

func _physics_process(delta: float) -> void:
	if !active:
		apply_gravity(delta)
	
	if Input.is_action_just_pressed("use") and active:
		print("item being used")
		
	move_and_slide()
