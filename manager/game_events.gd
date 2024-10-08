# Handles all global events in game. Is a singleton that can be used to emit signals across scenes.
extends Node

signal collectable_picked_up(collectable: CollectableResource)
signal heal_player(amount: int)
signal double_jump_gained
signal roll_ability_gained
signal start_cut_scene(scene: cut_scenes)
signal end_cut_scene(scene: cut_scenes)
signal water_pipe_fixed
signal control_panel_activated
signal game_completed

enum cut_scenes {
	START,
	DOOR,
	REPAIR,
	CONTROL_PANEL
	}


func emit_collectable_picked_up(collectable: CollectableResource):
	collectable_picked_up.emit(collectable)


func emit_heal_player(amount: int):
	heal_player.emit(amount)


func emit_double_jump_gained():
	double_jump_gained.emit()


func emit_start_cut_scene(scene: cut_scenes):
	start_cut_scene.emit(scene)


func emit_end_cut_scene(scene: cut_scenes):
	end_cut_scene.emit(scene)


func emit_water_pipe_fixed():
	water_pipe_fixed.emit()


func emit_control_panel_activated():
	control_panel_activated.emit()


func emit_game_completed():
	game_completed.emit()


func emit_roll_ability_gained():
	roll_ability_gained.emit()
