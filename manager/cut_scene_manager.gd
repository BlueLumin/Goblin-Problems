# Handles playing the cut scenes.
extends Node

@onready var cut_scene_animation_player: AnimationPlayer = $CutSceneAnimationPlayer
@onready var cut_scene_marker: Node2D = $CutSceneMarker

@export var player : Player
@export var camera : WorldCamera

var scene_manager: SceneManager


func _ready() -> void:
	scene_manager = get_tree().get_first_node_in_group("scene_manager")
	scene_manager.scene_loaded.connect(on_scene_loaded)
	
	GameEvents.start_cut_scene.connect(on_start_cut_scene)


# Sets the player as active (can be controlled by the user).
func activate_player():
	camera.target = player # Sets the game camera's target to the player.
	player.is_active = true


func cut_scene_START():
	var cut_scene_marker_pos = Vector2(50, 219) # The starting position of the camara.
	
	focus_cut_scene_marker(cut_scene_marker_pos, "start")


# Unlocking the shed door.
func cut_scene_DOOR():
	var cut_scene_marker_pos = camera.get_screen_center_position() # Get the centre of the screen
	
	MusicManager.change_song(MusicManager.music_playlist["shed"])
	
	await get_tree().create_timer(1).timeout # Wait for the door to fade (1 second)
	
	focus_cut_scene_marker(cut_scene_marker_pos, "door", true, 4605)


# Repaired the leaking pipe.
func cut_scene_REPAIR():
	var cut_scene_marker_pos = camera.get_screen_center_position() # Get the centre of the screen
	focus_cut_scene_marker(cut_scene_marker_pos, "repair")


# Turned on the control panal.
func cut_scene_CONTROL_PANEL():
	var cut_scene_marker_pos = camera.get_screen_center_position() # Get the centre of the screen
	
	MusicManager.change_song(MusicManager.music_playlist["completed"])
	
	focus_cut_scene_marker(cut_scene_marker_pos, "control_panel")


# Handles focusing the camera on the cut_scene_marker and updating the game camara's limit.
func focus_cut_scene_marker(
	start_pos: Vector2, # The positon the cut scene marker should begin.
	animation: String, # The cut scene animation that should be played.
	update_camera_limit : bool = false, # If true then update the camera right_limt.
	new_limit : int = 0 # If should updated the camera limit, specify the new left_limit.
	):
	cut_scene_marker.global_position = start_pos # Set the starting position.
	
	cut_scene_animation_player.get_animation(animation).track_set_key_value(0, 0, start_pos) # Edit the first key frame to start at the given starting position.
	var cut_scene_key_count = cut_scene_animation_player.get_animation(animation).track_get_key_count(0) # Get the total count of keys in the animation track.
	cut_scene_animation_player.get_animation(animation).track_set_key_value(0, (cut_scene_key_count - 1), player.global_position) # Edit the last key frame to center on the player.
	
	camera.global_position = start_pos # Set the camera's position to the new starting position.
	
	camera.target = cut_scene_marker # Assign the camera's target to the cut scene marker.
	
	if update_camera_limit == true: # If the cameras limits need to be updated, call method to do so.
		camera.update_camera_limits(new_limit)
	
	cut_scene_animation_player.play(animation) # Play the animation to move the marker.


func on_scene_loaded():
	if GlobalVariables.cut_scene_completed:
		activate_player()
		return
	
	cut_scene_START()


# Handles starting the cut scene and controls which animation plays based on the "scene" passed through.
func on_start_cut_scene(scene):
	if player == null:
		push_warning(self, " cannot locate player.")
		return
	
	player.is_active = false # Set the player to not active (stops movement).
	
	# Match the scene variable to the cut_scenes enum in GameEvents and call the appropriate function.
	match scene:
		GameEvents.cut_scenes.START: # Beginning of the game.
			cut_scene_START()
		GameEvents.cut_scenes.DOOR: # Open the shed door.
			cut_scene_DOOR()
		GameEvents.cut_scenes.REPAIR: # Repair the leaky pipe.
			cut_scene_REPAIR()
		GameEvents.cut_scenes.CONTROL_PANEL: # Turn on the control panal.
			cut_scene_CONTROL_PANEL()


func on_start_animation_finished():
	GlobalVariables.cut_scene_completed = true
	var tutorial_manager = get_tree().get_first_node_in_group("tutorial_manager") as TutorialManager
	tutorial_manager.start_tutorial("movement")


func on_control_panel_anaimation_finished():
	GameEvents.emit_game_completed()
