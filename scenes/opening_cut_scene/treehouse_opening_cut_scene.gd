extends Node

var scene_manager : SceneManager


func _ready() -> void:
	scene_manager = get_tree().get_first_node_in_group("scene_manager")
	
	await scene_manager.scene_loaded
	$AnimationPlayer.play("cut_scene")


func on_cut_scene_finished():
	if scene_manager == null:
		push_warning(self, " cannot locate SceneManager")
		return
	
	scene_manager.request_scene_change("res://scenes/world/world.tscn")
