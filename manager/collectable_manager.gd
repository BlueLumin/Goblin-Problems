# Handles collectables picked up by the player and stores them in a Dictionary.
extends Node
class_name CollectableManager

var current_collectables : Dictionary # A Dictionary that stores the collectable resources that have been picked up as well as the quantity.


func _ready() -> void:
	GameEvents.collectable_picked_up.connect(on_collectable_picked_up)


# Add a collectable to the current_collectables Dictionary.
func on_collectable_picked_up(collectable: CollectableResource):
	if current_collectables.has(collectable.collectable_id):
		# If collectable is already in current_collectable.
		current_collectables[collectable.collectable_id]["quantity"] += 1
	else:
		# If collectable is not in current_collectables, add it.
		current_collectables[collectable.collectable_id] = {
			"name": collectable.collectable_name,
			"quantity": 1,
		}
	
	# Execute based on item.
	match collectable.collectable_id:
		"heart":
			on_heart_picked_up()
		"double_jump":
			on_double_jump_picked_up()
		"roll":
			on_roll_picked_up()


# Checks if the collectable is already in the Dictionary and returns true or false.
func check_for_collectable(collectable: String):
	return current_collectables.has(collectable)


func on_heart_picked_up():
	GameEvents.emit_heal_player(1)


func on_double_jump_picked_up():
	GameEvents.emit_double_jump_gained()


func on_roll_picked_up():
	GameEvents.emit_roll_ability_gained()
	
	var tutorial_manager = get_tree().get_first_node_in_group("tutorial_manager") as TutorialManager
	
	if tutorial_manager == null:
		return
	
	tutorial_manager.start_tutorial("rolling")
