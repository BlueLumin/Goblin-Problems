# The object spawned by the MusicManager. Handles destorying the node once the sound effect is finished.
extends AudioStreamPlayer
class_name SoundEffectPlayer


func _ready() -> void:
	finished.connect(on_finished)


func on_finished():
	self.queue_free()
