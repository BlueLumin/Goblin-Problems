extends Node2D
class_name EnemyMovementComponent

@onready var ray_cast_group: Node2D = $RayCastGroup
@onready var ground_ray_cast: RayCast2D = $RayCastGroup/GroundRayCast
@onready var wall_ray_cast: RayCast2D = $RayCastGroup/WallRayCast
@onready var idle_timer: Timer = $IdleTimer

@export_group("Nodes")
@export var enemy_character_body : CharacterBody2D
@export var visuals : Node2D

@export_group("Movement Settings")
@export var max_speed = 40

var speed = 40
var facing_right : bool = true


func _ready():
	if enemy_character_body == null:
		set_physics_process(false)
	idle_timer.timeout.connect(on_idle_timer_timeout)


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not enemy_character_body.is_on_floor():
		enemy_character_body.velocity += enemy_character_body.get_gravity() * delta
	
	if speed != 0:
		if check_collisions() != null:
			idle()
	
	enemy_character_body.velocity.x = speed
	enemy_character_body.move_and_slide()


func check_collisions():
	if !ground_ray_cast.is_colliding() and enemy_character_body.is_on_floor():
		return "floor"
	
	if wall_ray_cast.is_colliding():
		return "wall"
	
	return null


func idle():
	speed = 0
	idle_timer.wait_time = randf_range(1, 3)
	idle_timer.start()
	
	if check_collisions() == "wall":
		change_direction()


func change_direction():
	facing_right = !facing_right # Invert
	ray_cast_group.scale.x = ray_cast_group.scale.x * -1
	visuals.scale.x = visuals.scale.x * -1


func move_in_new_direction():
	if facing_right:
		speed = abs(max_speed) # abs() returns the number without any negatives
	else:
		speed = abs(max_speed) * -1


func on_idle_timer_timeout():
	if check_collisions() == "floor":
		change_direction()
	
	move_in_new_direction()
