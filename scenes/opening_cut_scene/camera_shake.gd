# Controls the camera shake.
extends Camera2D

var random_strength: float = 10.0
var shake_fade: float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength:float = 0.0


func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		offset = random_offset()


func apply_shake():
	shake_strength = random_strength


func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
