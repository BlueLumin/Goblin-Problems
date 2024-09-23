extends AudioStreamPlayer
class_name SoundEffectPlayer


func _ready() -> void:
	finished.connect(on_finished)


func on_finished():
	self.queue_free()
