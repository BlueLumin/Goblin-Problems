extends Area2D

var collectable : CollectableResource


func _ready() -> void:
	collectable = owner
	if collectable == null:
		push_warning(self, " has no owner detected.")
		return
	
	body_entered.connect(on_body_entered)


func collect_tween():
	var tween = create_tween()
	tween.tween_property(owner, "scale", Vector2.ZERO, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	GameEvents.emit_collectable_picked_up(collectable)
	
	owner.queue_free()


func on_body_entered(body: CharacterBody2D):
	if not body is Player:
		return
	
	collect_tween()
	
	MusicManager.play_sound_effect(MusicManager.collectable[collectable.sound_type])
