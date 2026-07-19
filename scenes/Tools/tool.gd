extends RigidBody2D
class_name Tool
var active = false
var target: Sprite2D
signal trigger_minigame(type: int)

func _ready() -> void:
	lock_rotation = true
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC

func _physics_process(_delta: float) -> void:
	if active:
		global_position = get_global_mouse_position() - Vector2(7.5, 7.5)

	if Input.is_action_just_pressed("use") and active and target and !Global.minigame_mode:
		action(target)

func set_active(value: bool) -> void:
	active = value
	freeze = value  # frozen while held, physics re-enabled the instant it's dropped

func action(body_part: Sprite2D):
	pass
