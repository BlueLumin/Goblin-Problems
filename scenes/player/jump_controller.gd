extends Node
class_name JumpController

signal just_landed
signal just_left_floor
signal double_jumped

@onready var jump_window_timer: Timer = $JumpWindowTimer

@export_category("Player Jump")
@export var jump_velocity = 350.0
@export var max_jumps = 1

var player : Player
var jump_count = 0
var on_floor : bool


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		set_physics_process(false)
		return
	
	GameEvents.double_jump_gained.connect(on_double_jump_gained)
	
	jump_velocity *= -1 # Make the jump velocity a negitive number
	jump_window_timer.timeout.connect(on_jump_window_timer_timeout)


func _physics_process(delta: float) -> void:
	add_gravity(delta)
	
	check_if_on_floor()
	
	if player.is_active and player.player_input:
		# Jump Input
		if Input.is_action_just_pressed("jump"):
			jump()


func add_gravity(delta):
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta


func check_if_on_floor():
	if on_floor != player.is_on_floor():
		if on_floor == false:
			jump_count = 0 # Reset jump count when landing on the ground
			just_landed.emit()
		if on_floor == true and jump_count == 0:
			jump_window_timer.start() # If we leave the ground without jumping, start the timer
			just_left_floor.emit()
	on_floor = player.is_on_floor()


func jump():
	if jump_count < max_jumps:
		player.velocity.y = jump_velocity
		
		MusicManager.play_sound_effect(MusicManager.player["Jump"],0, true)
		
		if jump_count == 0:
			just_left_floor.emit()
		else:
			double_jumped.emit()
			
		jump_count += 1


func on_jump_window_timer_timeout():
	if jump_count == 0 and not player.is_on_floor():
		jump_count += 1


func on_double_jump_gained():
	max_jumps += 1
