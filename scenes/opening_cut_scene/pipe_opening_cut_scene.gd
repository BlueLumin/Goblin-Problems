extends Node2D

var scene_manager : SceneManager


func _ready() -> void:
	scene_manager = get_tree().get_first_node_in_group("scene_manager")
	
	MusicManager.change_song(MusicManager.music_playlist["cut_scene"])
	
	await scene_manager.scene_loaded
	$AnimationPlayer.play("cut_scene")


func on_cut_scene_animation_finished():
	if scene_manager == null:
		push_warning(self, " cannot locate SceneManager")
		return
	
	scene_manager.request_scene_change("res://scenes/opening_cut_scene/treehouse_opening_cut_scene.tscn")


func on_play_break_sound():
	MusicManager.play_sound_effect(MusicManager.cut_scene["PipeBreak"], 0)
