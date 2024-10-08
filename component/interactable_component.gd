# A component that can be added as a child to a node.
# Allows the player to interact with the parent node.
extends Area2D
class_name InteractableComponent

@export_group("Interactive Object Properties")
@export var object_id: String
@export var can_be_used: bool = true
@export_multiline var cannot_interact_message: String ## The message to be displayed when this object cannot be interacted with.
@export_multiline var on_interact_message: String ## The message to be displayed on interacting with the object

var interactive_manager: InteractiveManager

var interact: Callable # Will be set to a function by the parent node to control what happens on interacting.


func _ready() -> void:
	interactive_manager = get_tree().get_first_node_in_group("interactive_manager")


# Add self to the InteractiveManager active_areas Array.
func on_body_entered(body: Node2D):
	if interactive_manager == null:
		return
	
	interactive_manager.register_area(self)


# Remove self to the InteractiveManager active_areas Array.
func on_body_exited(body: Node2D):
	if interactive_manager == null:
		return
		
	interactive_manager.unregister_area(self)
