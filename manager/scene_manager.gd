extends Node2D
class_name SceneManager

signal scene_loaded
signal scene_faded

@onready var current_scene_node: Node2D = $CurrentScene

@export var fade_layer : PackedScene

var player : Player
var current_scene : String


func _ready() -> void:
	GameEvents.game_completed.connect(on_game_completed)
	
	connect_player()
	
	current_scene = current_scene_node.get_child(0).scene_file_path
	
	if current_scene == "res://scenes/world/world.tscn":
		scene_fade_in()


func connect_player():
	player = get_tree().get_first_node_in_group("player")
	
	if player != null:
		player.player_died.connect(on_player_died)
	else:
		if current_scene == "res://scenes/world/world.tscn":
			push_warning("No player assigned to the SceneManager.")


func scene_fade_in():
	var fade = fade_layer.instantiate() as FadeLayer
	fade.fade_type = fade.fades.OPEN
	
	self.add_child(fade)
	await fade.transition_completed
	scene_loaded.emit()


func change_scene(target_scene: String, fade_instance = null, end_screen = null):
	#current_scene_node.get_child(0).queue_free()
	
	var active_scenes = current_scene_node.get_children()
	
	for scene in active_scenes:
		scene.queue_free()
	
	
	var new_scene = load(target_scene).instantiate()
	
	if end_screen:
		new_scene.current_state = end_screen
	
	current_scene_node.add_child(new_scene)
	
	current_scene = target_scene
	
	await fade_instance.transition_completed
	scene_loaded.emit()
	
	connect_player() # Reconnects the player in the new scene


func request_scene_change(target_scene: String, end_screen = null):
	var fade = fade_layer.instantiate() as FadeLayer
	self.add_child(fade)
	
	await fade.fade_out_completed
	
	scene_faded.emit()
	change_scene(target_scene, fade, end_screen)


func on_game_completed():
	# Save number of shinies collected
	var shinies_count = get_node("CurrentScene/World/CollectableManager").current_collectables["shiney"]["quantity"]
	GlobalVariables.shinies_collected = shinies_count
	
	# Count the goblins left in the world
	var goblin_count = get_tree().get_first_node_in_group("entities_layer").get_child_count()
	GlobalVariables.goblins_left = goblin_count
	
	# Save the tutorials
	var tutorial_manager = get_tree().get_first_node_in_group("tutorial_manager") as TutorialManager
	GlobalVariables.tutorials = tutorial_manager.tutorials
	
	await get_tree().create_timer(1.5).timeout
	request_scene_change("res://ui/end_scene/end_scene.tscn", "win")


func on_player_died():
	await get_tree().create_timer(1.5).timeout
	request_scene_change("res://ui/end_scene/end_scene.tscn", "lose")
