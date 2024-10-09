# Handles playing music and sound effects and can be used from other scenes.
extends Node

@export var sound_effect_player: PackedScene

@onready var music_player_1: AudioStreamPlayer = $MusicPlayer1
@onready var music_player_2: AudioStreamPlayer = $MusicPlayer2

var changing_music: bool = false

var music_playlist: Dictionary = {
	"world": preload("res://music_and_sounds/music/Three Red Hearts - Puzzle Pieces.ogg"),
	"shed": preload("res://music_and_sounds/music/Three Red Hearts - Save the City.ogg"),
	"cut_scene": preload("res://music_and_sounds/music/Three Red Hearts - Rabbit Town.ogg"),
	"menu": preload("res://music_and_sounds/music/Three Red Hearts - Sanctuary.ogg"),
	"completed": preload("res://music_and_sounds/music/Three Red Hearts - Princess Quest (No Boing).ogg"),
	}

var player: Dictionary = {
	"Jump": preload("res://music_and_sounds/sounds/player_sounds/Jump.wav"),
	"PlayerDamage": preload("res://music_and_sounds/sounds/player_sounds/PlayerDamage.wav"),
	"PlayerDied": preload("res://music_and_sounds/sounds/player_sounds/PlayerDied.wav"),
	"PlayerWalk": preload("res://music_and_sounds/sounds/player_sounds/PlayerWalk.wav"),
	"Roll": preload("res://music_and_sounds/sounds/player_sounds/Roll.wav"),
	}
var goblin: Dictionary = {
	"GoblinDied": preload("res://music_and_sounds/sounds/goblin_sounds/GoblinDied.wav")
	}
var collectable: Dictionary = {
	"AbilitySound": preload("res://music_and_sounds/sounds/collectable_sounds/AbilitySound.wav"),
	"HealingSound": preload("res://music_and_sounds/sounds/collectable_sounds/HealingSound.wav"),
	"ShinySound": preload("res://music_and_sounds/sounds/collectable_sounds/ShinySound.wav"),
	"ToolSound": preload("res://music_and_sounds/sounds/collectable_sounds/ToolSound.wav"),
	}
var cut_scene: Dictionary = {
	"PipeBreak": preload("res://music_and_sounds/sounds/cut_scene_sounds/PipeBreak.wav"),
	}
var enviroment: Dictionary = {
	"ControlPanel": preload("res://music_and_sounds/sounds/enviroment_sounds/ControlPanel.wav"),
	"DoorUnlock": preload("res://music_and_sounds/sounds/enviroment_sounds/DoorUnlock.wav"),
	"NoInteract": preload("res://music_and_sounds/sounds/enviroment_sounds/NoInteract.wav"),
	"PipeRepair": preload("res://music_and_sounds/sounds/enviroment_sounds/PipeRepair.wav"),
	}
var ui: Dictionary = {
	"Click": preload("res://music_and_sounds/sounds/ui_sounds/Click.ogg"),
	"Tutorial": preload("res://music_and_sounds/sounds/ui_sounds/Tutorial.ogg")
	}


#func _ready() -> void:
	#create_folder(player)
	#create_folder(goblin)
	#create_folder(collectable)
	#create_folder(cut_scene)
	#create_folder(enviroment)
	#create_folder(ui)


#func create_folder(folder: Dictionary): ## Populates the passed through dictionary with files
	#var dir = DirAccess.open(folder["folder"])
	#if dir:
		#
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#
		#while file_name != "":
			#if not dir.current_is_dir():
				#if !file_name.begins_with(".") and !file_name.ends_with(".import"):
					#folder[file_name.erase(file_name.find(".wav"), 4)] = load(folder["folder"] + "/" + file_name)
				#
			#file_name = dir.get_next()


func play_sound_effect(sound, volume = 0, rand_pitch: bool = false):
	var sound_effect_player_instance = sound_effect_player.instantiate()
	sound_effect_player_instance.set_stream(sound)
	sound_effect_player_instance.volume_db = volume
	if rand_pitch:
		sound_effect_player_instance.set_pitch_scale(randf_range(0.9, 1.1))
	add_child(sound_effect_player_instance)
	sound_effect_player_instance.play()


func change_song(new_song):
	if changing_music:
		return
	
	changing_music = true
	
	var active_player = get_active_player()
	var inactive_player = get_inactive_player()
	
	inactive_player.set_stream(new_song)
	inactive_player.volume_db = -80
	inactive_player.play()
	
	var tween = create_tween()
	tween.set_parallel()
	if active_player:
		tween.tween_property(active_player, "volume_db", -80, 1.20) # Fade out previous music
	tween.tween_property(inactive_player, "volume_db", 0, 0.70) # Fade in new music
	
	await tween.finished
	
	if active_player:
		active_player.stop()
		
	changing_music = false


func fade_music_out():
	var active_player = get_active_player()
	
	if not active_player:
		return
	
	var tween = create_tween()
	tween.tween_property(active_player, "volume_db", -80, 1.50)
	
	await tween.finished
	
	active_player.stop()


func get_active_player(): ## Used to retrieve which AudioPlayer is currently active
	if music_player_1.playing:
		return music_player_1
	elif music_player_2.playing:
		return music_player_2
	else:
		return null


func get_inactive_player(): ## Used to retrieve which AudioPlayer is currently inactive
	if not music_player_1.playing:
		return music_player_1
	elif not music_player_2.playing:
		return music_player_2
	else:
		return null
