extends Node2D

@export_category("Textures")
@export var death_texture_1 : Texture ## The primary death texture
@export var death_texture_2 : Texture ## The secondary death texture

@export_category("Node Links")
@export var health_component : HealthComponent

@onready var primary_gpu_particles: GPUParticles2D = $PrimaryGPUParticles
@onready var secondary_gpu_particles: GPUParticles2D = $SecondaryGPUParticles
@onready var primary_animation_player: AnimationPlayer = $PrimaryAnimationPlayer
@onready var secondary_animation_player: AnimationPlayer = $SecondaryAnimationPlayer


func _ready() -> void:
	if death_texture_1 != null:
		primary_gpu_particles.set_texture(death_texture_1)
	
	if death_texture_2 != null:
		secondary_gpu_particles.set_texture(death_texture_2)
	
	if health_component == null:
		return
	
	health_component.died.connect(on_death)


func on_death():
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	
	get_parent().remove_child(self)
	entities.add_child(self)
	self.global_position = spawn_position
	
	if death_texture_1 != null:
		primary_animation_player.play("primary_particle")
	
	if death_texture_2 != null:
		secondary_animation_player.play("secondary_particle")
