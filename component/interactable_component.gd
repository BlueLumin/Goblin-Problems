extends Area2D
class_name InteractableComponent

@export_group("Interactive Object Properties")
@export var object_id: String
@export var can_be_used: bool = true
@export_multiline var cannot_interact_message: String ## The message to be displayed when this object cannot be interacted with.
@export_multiline var on_interact_message: String ## The message to be displayed on interacting with the object

var interactive_manager: InteractiveManager

var interact: Callable


func _ready() -> void:
	interactive_manager = get_tree().get_first_node_in_group("interactive_manager")


func on_body_entered(body: Node2D):
	interactive_manager.register_area(self)


func on_body_exited(body: Node2D):
	interactive_manager.unregister_area(self)
