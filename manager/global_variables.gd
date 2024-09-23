extends Node

var death_particles = preload("res://resource/death_component_particle.tres")
var water_particles = preload("res://scenes/enviroment/water_pipe/water_pipe_gpu_particles.tres")

var cut_scene_completed : bool = false

# END GAME VARIABLES
var total_shinies: int
var shinies_collected: int
var goblins_left: int

var tutorials : Dictionary = {
	"movement": {
		"completed": false,
		"tutorial_text": "WASD or the arrow keys to move.\n\nSpacebar, W, or the up arrow to jump.\n\nS or down arrow to fall through platforms.",
	},
	"knife_goblins": {
		"completed": false,
		"tutorial_text": "Goblins with knives!\n\nJump on their heads to get rid of them.\n\nBe careful! If they get too close they might hurt you.",
	},
	"rolling": {
		"completed": false,
		"tutorial_text": "You've learned how to roll by pressing SHIFT.",
	},
	"spiker_goblins": {
		"completed": false,
		"tutorial_text": "These goblins carry spikes!\n\nJumping on them will hurt.\n\nTry rolling through them to knock them away.",
	},
}


func _ready() -> void:
	load_particles(death_particles)
	load_particles(water_particles)


func load_particles(particles):
	var particles_instance = GPUParticles2D.new()
	particles_instance.set_process_material(particles)
	particles_instance.set_one_shot(true)
	particles_instance.set_emitting(true)
	particles_instance.set_lifetime(2.0)
	self.add_child(particles_instance)
