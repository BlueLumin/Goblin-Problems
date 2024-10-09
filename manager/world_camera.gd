# The game camera that can focus on a designated target.
extends Camera2D
class_name WorldCamera

@export var player : Player

var target : Node2D
var move_to_new_position: bool = false
var new_postion : Vector2


func _ready() -> void:
	update_camera_limits(2529)
	# 2529 = START
	# 4605 = SHED


func _physics_process(delta: float) -> void:
	if not target == null:
		camera_follow_position(target.global_position, delta)
		
		if target is Player:
			if player.is_on_floor():
				tween_top_drag_limit(0, 1)
			else:
				tween_top_drag_limit(0.6, 0.3)
		else:
			tween_top_drag_limit(0, 1)


func camera_follow_position(target_position: Vector2, delta):
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))


func update_camera_limits(new_limit: int):
	set_limit(SIDE_RIGHT, new_limit)


func tween_top_drag_limit(drag_target: float, duration: float):
	var tween = create_tween()
	tween.tween_property(self, "drag_top_margin", drag_target, duration)
