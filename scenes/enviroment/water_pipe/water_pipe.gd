extends Node2D

@onready var tape_fix_sprite: Sprite2D = $TapeFixSprite
@onready var water_pipe_gpu_particles: GPUParticles2D = $WaterPipeGPUParticles
@onready var interactable_component: InteractableComponent = $InteractableComponent

var fixed: bool = false
var collectable_manager: CollectableManager

func _ready() -> void:
	break_pipe()
	
	collectable_manager = get_tree().get_first_node_in_group("collectable_manager")
	
	if interactable_component == null:
		return
	
	interactable_component.interact = Callable(self, "on_interact")


func on_interact():
	var create_notification_text = get_tree().get_first_node_in_group("HUD").create_notification_text
	
	if not interactable_component.can_be_used:
		return
	
	if collectable_manager == null:
		push_warning(self, " cannot locate the CollectableManager.")
		return
	
	if collectable_manager.current_collectables.has("tape"):
		create_notification_text.call(interactable_component.on_interact_message)
		repair_pipe()
		MusicManager.play_sound_effect(MusicManager.enviroment["PipeRepair"], 10)
	else:
		create_notification_text.call(interactable_component.cannot_interact_message)
		MusicManager.play_sound_effect(MusicManager.enviroment["NoInteract"], -10)


func break_pipe():
	tape_fix_sprite.visible = false
	water_pipe_gpu_particles.emitting = true


func repair_pipe():
	interactable_component.can_be_used = false
	
	GameEvents.emit_water_pipe_fixed()
	
	tape_fix_sprite.visible = true
	water_pipe_gpu_particles.emitting = false
	
	GameEvents.emit_start_cut_scene(GameEvents.cut_scenes.REPAIR)
