# A component that can be added as a child to a node.
# Handles the "death" of the node.
extends Node2D

# The textures to be used in the death particle. 
# Primary is for the body of the node. Secondary is for any equipment the node might need displayed.
@export_category("Textures")
@export var death_texture_1 : Texture ## The primary death texture
@export var death_texture_2 : Texture ## The secondary death texture

@export_category("Node Links")
@export var health_component : HealthComponent # The reference to the HealthComponent of the parent node.

@onready var primary_gpu_particles: GPUParticles2D = $PrimaryGPUParticles
@onready var secondary_gpu_particles: GPUParticles2D = $SecondaryGPUParticles
@onready var primary_animation_player: AnimationPlayer = $PrimaryAnimationPlayer
@onready var secondary_animation_player: AnimationPlayer = $SecondaryAnimationPlayer


func _ready() -> void:
	if death_texture_1 != null:
		# Set the gpu particles to the primary texture on ready.
		primary_gpu_particles.set_texture(death_texture_1)
	
	if death_texture_2 != null:
		# Set the gpu particles to the secondary texture on ready.
		secondary_gpu_particles.set_texture(death_texture_2)
	
	if health_component == null:
		return
	
	health_component.died.connect(on_death)


# Called from the HealthComponent node. Handles spawning the death textures.
func on_death():
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer") # Gets the layer to spawn the textures on.
	
	# Removes itself from the parent node and places itself into the entites layer (so that it isn't destoryed with the parent node)
	get_parent().remove_child(self)
	entities.add_child(self)
	self.global_position = spawn_position
	
	if death_texture_1 != null:
		primary_animation_player.play("primary_particle")
	
	if death_texture_2 != null:
		secondary_animation_player.play("secondary_particle")

# queue_free() is called from the PrimaryAnimationPlayer
