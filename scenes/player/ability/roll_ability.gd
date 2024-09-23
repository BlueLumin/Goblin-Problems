extends Node2D
class_name RollAbility

@export var roll_speed : float = 200
@export var is_active: bool = false

@onready var roll_cooldown_timer: Timer = $RollCooldownTimer
@onready var hit_box_component: HitBoxComponent = $HitBoxComponent

var player : Player


func _ready():
	GameEvents.roll_ability_gained.connect(on_roll_ability_gained)
	
	roll_cooldown_timer.timeout.connect(on_roll_cooldown_timer_timeout)
	
	player = get_tree().get_first_node_in_group("player")
	
	if player == null:
		set_physics_process(false)
		push_warning("No player found by the RollAbility")
		return
	
	player.player_stopped_rolling.connect(on_roll_ended)
	player.jump_controller.just_left_floor.connect(on_just_left_floor)
	player.jump_controller.just_landed.connect(on_just_landed)


func _physics_process(delta: float) -> void:
	if is_active:
		
		if player.is_rolling:
			if player.direction != 0:
				player.velocity.x = player.direction * roll_speed
			else:
				var facing_direction = player.visuals.scale.x
				player.velocity.x = facing_direction * roll_speed
			
			# Rolling safety check
			if is_roll_animation_playing() == false:
				await get_tree().create_timer(0.15).timeout
				if is_roll_animation_playing() == false:
					on_roll_ended()


func is_roll_animation_playing() -> bool:
	if player.animation_state_machine.get_current_node() == "roll":
		return true
	
	return false


func _input(event: InputEvent) -> void:
	if is_active:
		
		if player.is_active and player.player_input:
			if event.is_action_pressed("roll"):
				if player.can_roll and player.is_on_floor():
					roll()


func roll():
	if player == null:
		return
	
	MusicManager.play_sound_effect(MusicManager.player["Roll"])
	
	player.animation_state_machine.travel("roll")
	player.is_rolling = true
	player.player_input = false
	player.can_roll = false
	
	hit_box_component.monitorable = true # Turn on HitBox to deal damage while rolling
	player.hurt_box.set_collision_mask_value(9, false) # Disable SpikerGoblin monitoring
	
	roll_cooldown_timer.start()


func on_roll_ended(): # Called from the animation player
	if player == null:
		return
	
	player.is_rolling = false
	player.player_input = true
	
	hit_box_component.monitorable = false # Turn off HitBox after rolling
	player.hurt_box.set_collision_mask_value(9, true) # Enable Spiker Goblin monitoring


func on_roll_cooldown_timer_timeout():
	player.can_roll = true


func on_just_left_floor():
	player.can_roll = false


func on_just_landed():
	await get_tree().create_timer(0.20).timeout
	player.can_roll = true


func on_roll_ability_gained():
	is_active = true
