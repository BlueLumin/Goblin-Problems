# A component that can be added as a child to a node.
# Handles taking damage, health, healing, and death.
extends Node2D
class_name HealthComponent

signal died # Emitted when the parent has lost all of it's health.
signal took_damage # Emitted when the parent has taken damage.

enum entity_type {PLAYER, ENEMY} # Used to determain if the parent is an "Enemy" or the "Player".

@export var hurt_box : HurtBoxComponent ## The HurtBoxComponent of the entity
@export var max_health = 1 ## The entity's max health.
@export var type : entity_type = entity_type.ENEMY ## The type of entity.

var current_health : int


func _ready() -> void:
	current_health = max_health # Set the current health to the entity's max health.
	hurt_box.took_damage.connect(take_damage)
	
	if type == entity_type.PLAYER:
		GameEvents.heal_player.connect(on_heal_player)


# Called from the HurtBox component on collision with a HitBox.
func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	took_damage.emit()
	
	if type == entity_type.PLAYER:
		update_player_health()
	
	if current_health <= 0:
		die()


# Called from the take_damage() function when the current health reaches 0.
func die():
	died.emit()
	owner.queue_free()


# Called if the type variable is PLAYER and the current_health variable changes.
func update_player_health():
	var player = get_tree().get_first_node_in_group("player") as Player
	player.emit_health_updated(current_health)


# Called from the GameEvents singleton when the player heals.
func on_heal_player(amount: int):
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	update_player_health()
