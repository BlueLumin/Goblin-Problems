extends CanvasLayer

@onready var notification_container: VBoxContainer = $NotificationContainer/VBoxContainer
@onready var heart_display: TextureRect = $HeartDisplay
@onready var shiney_things_label: Label = $ShineyThingsContainer/VBoxContainer/HBoxContainer/ShineyThingsLabel

@export var notification_label : PackedScene
@export var shinies_group : Node2D

@onready var player : Player = get_tree().get_first_node_in_group("player")

var total_shinies : int


func _ready() -> void:
	GameEvents.collectable_picked_up.connect(on_collectable_picked_up)
	
	if player != null:
		player.health_updated.connect(on_health_updated_ui)
		on_health_updated_ui(player.health_component.max_health)
	
	if shinies_group != null:
		total_shinies = shinies_group.get_child_count()
		GlobalVariables.total_shinies = total_shinies
		update_shiney_things_label()
	
	var scene_manager = get_tree().get_first_node_in_group("scene_manager") as SceneManager
	if scene_manager != null:
		scene_manager.scene_loaded.connect(on_scene_loaded)


func create_notification_text(text: String):
	handle_notification_count() # Remove older notifications
	
	var notification_instance = notification_label.instantiate()
	notification_container.add_child(notification_instance)
	notification_instance.text = text


func handle_notification_count():
	var notification_list: Array = notification_container.get_children()
	var notification_limit = 4 # The max existing notifications there can be when creating a new one
	
	if notification_list.size() >= notification_limit: # If notifications are at limit
		var difference = (notification_list.size() - notification_limit) + 1 # Add 1 to ensure the newly added notification keeps the limit
		
		for label in difference: # Loop through notifications starting from the oldest (index 0)
			notification_list[label].tween_fade_out(0.5, 0)


func update_shiney_things_label():
	var collectable_manager = get_tree().get_first_node_in_group("collectable_manager") as CollectableManager
	var shiney_things_count : int
	
	if collectable_manager.current_collectables.has("shiney"):
		shiney_things_count = collectable_manager.current_collectables["shiney"]["quantity"]
	else:
		shiney_things_count = 0
	
	shiney_things_label.text = str(shiney_things_count) + " of " + str(total_shinies)


func on_scene_loaded():
	total_shinies = shinies_group.get_child_count()
	update_shiney_things_label()


func on_health_updated_ui(new_value: int):
	var number_of_hearts = new_value * 14
	var new_size = Vector2(number_of_hearts, 21)
	heart_display.set_size(new_size)


func on_collectable_picked_up(collectable: CollectableResource):
	if notification_label == null:
		push_warning("HUD has no notification_label scene assigned.")
		return
	
	create_notification_text(collectable.notfication_text)
	
	if collectable.collectable_id == "shiney":
		update_shiney_things_label()
