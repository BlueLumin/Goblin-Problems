# The primary script for the Goblin Enemy.
# Handles linking children components and animations.
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if health_component:
		health_component.took_damage.connect(on_took_damage)


func _physics_process(delta: float) -> void:
	play_animation()


func play_animation():
	if velocity.x != 0:
		animation_player.play("walk")
	elif animation_player.current_animation != "idle":
		animation_player.play("knife_spin")


func on_flip_animation_finished():
	animation_player.play("idle")


func on_took_damage():
	MusicManager.play_sound_effect(MusicManager.goblin["GoblinDied"])
