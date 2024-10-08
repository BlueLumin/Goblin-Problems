# Handles the player interacting with an InteractableComponent. 
extends Node
class_name InteractiveManager

@onready var interact_sprite: Sprite2D = $InteractSprite # The "thought bubble" sprite that indicate the player can interact.
@onready var player : Player

var active_areas : Array = [] # Stores all the InteractableComponents that are within range.
var can_interact : bool = true # Can the player currently interact?


func _physics_process(delta: float) -> void:
	if player == null:
		get_player()
		return
	
	interact_sprite.global_position = Vector2(player.global_position.x + 24, player.global_position.y - 32)
	
	
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(sort_by_distance_to_player)
		
		if active_areas[0].can_be_used:
			interact_sprite.visible = true
		else:
			interact_sprite.visible = false
	else:
		interact_sprite.visible = false
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			
			await active_areas[0].interact.call()
			can_interact = true


func register_area(area: InteractableComponent):
	active_areas.push_back(area)


func unregister_area(area: InteractableComponent):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func get_player():
	player = get_tree().get_first_node_in_group("player")


func sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.direction_to(area1.global_position)
	var area2_to_player = player.global_position.direction_to(area2.global_position)
	
	return area1_to_player < area2_to_player # Return true if area1 distance is smaller than area2
