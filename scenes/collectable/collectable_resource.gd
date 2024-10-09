# Handles the metadata and animation for collectable resources.
extends Node2D
class_name CollectableResource

@export_placeholder("collectable_id") var collectable_id : String ## The id of the collectable
@export_placeholder("Collectable Name") var collectable_name : String ## The name of the collectable
@export var hover: bool = true
@export_enum("AbilitySound", "HealingSound", "ShinySound", "ToolSound") var sound_type: String
@export_multiline var notfication_text : String ## The text that will show when this item is collected


func _ready() -> void:
	if hover:
		hover_up()


func hover_up():
	var tween = create_tween()
	tween.tween_property(self, "global_position:y", global_position.y - 4, 1)
	await tween.finished
	hover_down()


func hover_down():
	var tween = create_tween()
	tween.tween_property(self, "global_position:y", global_position.y + 4, 1)
	await tween.finished
	hover_up()
