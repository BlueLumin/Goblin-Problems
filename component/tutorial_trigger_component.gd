extends Area2D

@export var tutorial : String

var tutorial_manager : TutorialManager


func _ready() -> void:
	tutorial_manager = get_tutorial_manager()
	
	if tutorial_manager == null:
		push_warning(self, " cannot locate the TutorialManager node.")
		return
	
	body_entered.connect(on_body_entered)


func get_tutorial_manager():
	var temp_tutorial_manager = get_tree().get_first_node_in_group("tutorial_manager") 
	
	if temp_tutorial_manager != null:
		return temp_tutorial_manager
	else:
		push_warning(self, " cannot locate the TutorialManager node.")
		return null


func on_body_entered(body: Node2D):
	if not body is Player:
		return
	
	if tutorial_manager == null: # Check if there is an active tutorial manager assigned. Otherwise assign it.
		tutorial_manager = get_tutorial_manager()
	
	tutorial_manager.start_tutorial(tutorial)
	queue_free()
