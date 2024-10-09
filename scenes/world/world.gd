# The root script for the World node.
extends Node

var scene_manager: SceneManager


func _ready() -> void:
	MusicManager.change_song(MusicManager.music_playlist["world"])
