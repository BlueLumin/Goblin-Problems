extends CanvasLayer
class_name FadeLayer

signal transition_completed
signal fade_out_completed

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum fades {TRANSITION, OPEN}

var fade_type : fades = fades.TRANSITION


func _ready() -> void:
	if fade_type == fades.TRANSITION:
		transition()
	elif fade_type == fades.OPEN:
		fade_in()


func transition():
	animation_player.play("fade_out")


func fade_in():
	animation_player.play("fade_in")


func on_fade_out_completed():
	fade_out_completed.emit()
	await get_tree().create_timer(0.2).timeout
	fade_in()


func emit_transition_completed():
	transition_completed.emit()
	queue_free()
