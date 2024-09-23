extends Sprite2D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var lever_down: StaticBody2D = $LeverDown
@onready var lever_up: StaticBody2D = $LeverUp
@onready var out_of_order_label: Label = $OutOfOrderLabel

var has_water_piped_been_fixed: bool = false


func _ready() -> void:
	set_inactive()
	
	GameEvents.water_pipe_fixed.connect(on_water_pipe_fixed)
	
	if interactable_component == null:
		return
	interactable_component.interact = Callable(self, "on_interact") # Set the Callable varible to the on_interact function


func on_interact():
	var create_notification_text = get_tree().get_first_node_in_group("HUD").create_notification_text
	
	if not interactable_component.can_be_used:
		return # If this object is set to cannot_be_used, then dont run
	
	if has_water_piped_been_fixed:
		create_notification_text.call(interactable_component.on_interact_message)
		set_active()
		MusicManager.play_sound_effect(MusicManager.enviroment["ControlPanel"])
	else:
		# Create a notification that you cannot interact
		create_notification_text.call(interactable_component.cannot_interact_message)
		MusicManager.play_sound_effect(MusicManager.enviroment["NoInteract"], -10)


func set_active():
	self_modulate = "#ffffff"
	lever_down.set_collision_layer_value(1, true)
	lever_up.set_collision_layer_value(1, false)
	
	out_of_order_label.text = "FUNCTIONING"
	
	interactable_component.can_be_used = false
	GameEvents.emit_control_panel_activated()
	
	GameEvents.emit_start_cut_scene(GameEvents.cut_scenes.CONTROL_PANEL)


func set_inactive():
	self_modulate = "#ffffff00"
	lever_down.set_collision_layer_value(1, false)
	lever_up.set_collision_layer_value(1, true)
	
	out_of_order_label.text = "OUT OF ORDER"
	
	interactable_component.can_be_used = true


func on_water_pipe_fixed():
	has_water_piped_been_fixed = true
