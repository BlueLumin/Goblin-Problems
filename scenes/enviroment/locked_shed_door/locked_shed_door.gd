# Handles the interaction and unlocking of the shed door.
extends StaticBody2D

@onready var unlock_area: Area2D = $UnlockArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var collectable_manager : CollectableManager

@export var hud : CanvasLayer
var unlocked : bool = false # Not currently being used...


func _ready() -> void:
	unlock_area.body_entered.connect(on_unlock_area_entered)


func check_for_key() -> bool:
	# Check for "key" collectable id in the current_collectables Dictionary.
	return collectable_manager.current_collectables.has("key")


func unlock_door():
	animation_player.play("fade")
	GameEvents.emit_start_cut_scene(GameEvents.cut_scenes.DOOR) # Signal the cut scene manager to begin the cut scene.
	hud.create_notification_text("The shed door has been unlocked!")
	MusicManager.play_sound_effect(MusicManager.enviroment["DoorUnlock"])


func on_unlock_area_entered(body: Node2D):
	if not body is Player:
		return
	
	if collectable_manager:
		if check_for_key():
			unlock_door()
		else:
			if hud == null:
				push_warning("No HUD found from locked shed door instance")
				return
			
			hud.create_notification_text("This door needs a key to be unlocked...")
			MusicManager.play_sound_effect(MusicManager.enviroment["NoInteract"], -10)


func on_door_unlocked(): # Called from the animation player
	unlocked = true
	queue_free()
