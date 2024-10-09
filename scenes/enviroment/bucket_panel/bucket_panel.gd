# Handles the hiding of the foreground panel when the player enters the area.
extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func on_body_entered(body: Node2D):
	if not body is Player:
		return
	
	animation_player.play("fade_out")


func on_body_exited(body: Node2D):
	if not body is Player:
		return
	
	animation_player.play("fade_in")
