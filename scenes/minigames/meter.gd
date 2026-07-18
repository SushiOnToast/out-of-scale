extends Sprite2D

signal minigame_finished()

var active = false
@export var wobble_speed: float = 3.0
@export var wobble_radius: float = 15.0
@export var fill_speed: float = 0.1
@export var drain_speed: float = 0.2

var base_position: Vector2
var time_elapsed: float = 0.0
var progress: float = 0.0

func _ready() -> void:
	base_position = position
	time_elapsed = randf_range(0, 100)

func _process(delta: float) -> void:
	# wobble movement
	time_elapsed += delta
	var offset_x = sin(time_elapsed * wobble_speed) * wobble_radius
	var offset_y = cos(time_elapsed * wobble_speed * 0.7) * wobble_radius
	position = base_position + Vector2(offset_x, offset_y)

	# fill/drain based on hover
	if active:
		progress += fill_speed * delta
	else:
		progress -= drain_speed * delta
	progress = clamp(progress, 0.0, 1.0)

	update_visual(progress)

	if progress >= 1.5:
		minigame_finished.emit()

func update_visual(value: float) -> void:
	var anim_length = $AnimationPlayer.get_animation("tick").length
	$AnimationPlayer.current_animation = "tick"
	$AnimationPlayer.seek(value * anim_length, true)

func _on_area_2d_mouse_entered() -> void:
	active = true
func _on_area_2d_mouse_exited() -> void:
	active = false
