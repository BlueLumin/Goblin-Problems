extends Label


func _ready() -> void:
	tween_fade_out(1,3)


func tween_fade_out(duration: int, delay: int):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, duration).set_delay(delay)
	await tween.finished
	queue_free()
