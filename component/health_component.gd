extends Node2D
class_name HealthComponent

signal died
signal took_damage

enum entity_type {PLAYER, ENEMY}

@export var hurt_box : HurtBoxComponent ## The HurtBoxComponent of the entity
@export var max_health = 1 ## The entity's max health.
@export var type : entity_type = entity_type.ENEMY ## The type of entity.

var current_health : int


func _ready() -> void:
	current_health = max_health
	hurt_box.took_damage.connect(take_damage)
	
	if type == entity_type.PLAYER:
		GameEvents.heal_player.connect(on_heal_player)


func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	took_damage.emit()
	
	if type == entity_type.PLAYER:
		update_player_health()
	
	if current_health <= 0:
		die()


func die():
	
	died.emit()
	owner.queue_free()


func update_player_health():
	var player = get_tree().get_first_node_in_group("player") as Player
	player.emit_health_updated(current_health)


func on_heal_player(amount: int):
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	update_player_health()
