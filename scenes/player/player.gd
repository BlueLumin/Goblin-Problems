# The root script for the Player.
extends CharacterBody2D
class_name Player

signal health_updated(new_value: int)
signal player_died
signal player_stopped_rolling

@onready var visuals: Node2D = $Visuals
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

@export_category("Component Nodes")
@export var health_component : HealthComponent
@export var hurt_box : HurtBoxComponent
@export var jump_controller : JumpController

@export_category("Player Movement")
@export var max_speed = 100.00
@export var acceleration = 10.0
@export var friction = 20.0

var animation_state_machine: AnimationNodeStateMachinePlayback
var direction : float # Left and Right direction
var player_input : bool = true # Can receive player input
var is_rolling : bool = false
var can_roll : bool = true

var is_active : bool = false:
	set(value): # Toggle hurt_box monitoring with is_active so player doesn't take damage when not active.
		hurt_box.monitoring = value
		is_active = value
 

func _ready() -> void:
	if animation_tree != null:
		animation_state_machine = animation_tree["parameters/playback"]
	if health_component != null:
		health_component.died.connect(on_died)
		health_component.took_damage.connect(on_took_damage)
	if hurt_box != null:
		hurt_box.move_away_from_damage.connect(on_move_away_from_damage)
	if jump_controller != null:
		jump_controller.just_landed.connect(on_just_landed)
		jump_controller.just_left_floor.connect(on_just_left_floor)
		jump_controller.double_jumped.connect(on_double_jumped)


func _physics_process(delta: float) -> void:
	if is_active:
		if player_input:
			move(delta)
	else: # If not active, ensure one way platforms are solid.
		set_collision_mask_value(6, true)
		velocity.x = 0
	
	move_and_slide()
	
	play_animation_walking()


func get_input():
	direction = Input.get_axis("left", "right")


func move(delta: float) -> void:
	get_input()
	# Left and right movement.
	if !is_rolling: # Move at normal speed if not rolling.
		if direction:
			var target_velocity_x : float = direction * max_speed
			velocity.x = lerp(velocity.x, target_velocity_x, 1.0 - exp(-delta * acceleration))
		else:
			velocity.x = move_toward(velocity.x, 0, friction)
	
	# Fall through one way platforms.
	if Input.is_action_just_pressed("down"):
		set_collision_mask_value(6, false)
	
	if Input.is_action_just_released("down"):
		set_collision_mask_value(6, true)


func play_animation_walking():
	if !is_rolling:
		if velocity.x != 0 and is_on_floor():
			animation_state_machine.travel("walk")
		elif velocity.x == 0 and is_on_floor():
			animation_state_machine.travel("idle")
	
	# Flip sprite.
	if direction != 0:
		visuals.scale.x = sign(direction)


func on_just_landed():
	animation_state_machine.travel("land")


func on_just_left_floor():
	animation_state_machine.travel("jump")


func on_double_jumped():
	animation_state_machine.travel("double_jump")


func emit_health_updated(new_value: int):
	health_updated.emit(new_value)


# Bounce away from HitBoxCollison on taking damage.
func on_move_away_from_damage(collison_position : Vector2):
	if not is_rolling:
		
		var current_velocity = velocity # Store the current velocity (direction the player is moving).
		var target_velocity : Vector2 # The target speed on the x and y axis we want the player to move.
		
		player_input = false # Disable the player's input.
		
		var angle_to_collison = position.angle_to_point(collison_position) # The angle from the player to the collison.
		var target_direction = position.direction_to(collison_position) * -1 # For if the player has no velocity, get the direction to the collison and reverse it.
		
		if velocity.length() != 0: # Check if the player is moving.
			if velocity.y == 0: # Check if the player is not moving on the y axis.
				target_velocity = Vector2(current_velocity.x, current_velocity.y) # Target velocity is the current velocity.x amplified for knockback.
				velocity = target_velocity.rotated(angle_to_collison)
			else: # If the player is moving on the y axis (is jumping or falling).
				target_velocity = Vector2(0, 350) # Target velocity is only on the y axis (bounce upwards).
				velocity = target_velocity.rotated(angle_to_collison)
		else: # If the player is not moving, use the target direction * a set speed to move away.
			velocity = target_direction * 300
		
		await get_tree().create_timer(0.15).timeout # Disable player input for this duration, then re-enable.
		player_input = true

func on_took_damage():
	MusicManager.play_sound_effect(MusicManager.player["PlayerDamage"])


func on_died():
	MusicManager.play_sound_effect(MusicManager.player["PlayerDied"])
	MusicManager.fade_music_out()
	player_died.emit()


func emit_player_stopped_rolling(): # Emitted from the animation player and listened by the RollAbility.
	player_stopped_rolling.emit()
